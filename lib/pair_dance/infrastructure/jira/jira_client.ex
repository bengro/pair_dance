defmodule PairDance.Infrastructure.Jira.JiraClient do
  alias PairDance.Infrastructure.Integrations.EctoRepository, as: IntegrationsRepository

  @behaviour PairDance.Infrastructure.Jira.Operations

  @auth_atlassian "https://auth.atlassian.com/oauth/token"
  @api_atlassian "https://api.atlassian.com"

  @doc """
  Creates an integration by issuing token set using authorization_code grant type. Persists integration with metadata to be configured further.
  """
  def connect(team_id, auth_code) do
    {:ok, response} =
      Finch.build(
        :post,
        @auth_atlassian,
        [
          {"Content-Type", "application/json"}
        ],
        Jason.encode!(%{
          "grant_type" => "authorization_code",
          "code" => auth_code,
          "redirect_uri" => Application.get_env(:pair_dance, :jira_redirect_uri),
          "client_id" => Application.get_env(:pair_dance, :jira_client_id),
          "client_secret" => Application.get_env(:pair_dance, :jira_client_secret)
        })
      )
      |> Finch.request(PairDance.Finch)

    payload = Jason.decode!(response.body)

    token_settings = %{
      refresh_token: payload["refresh_token"],
      access_token: payload["access_token"],
      access_token_expiry: token_expiry_date(payload["expires_in"])
    }

    {:ok, integration} = IntegrationsRepository.create(team_id, token_settings)
    metadata = get_token_metadata(integration)

    {:ok, integration} =
      IntegrationsRepository.update_settings(integration.id, %{
        base_url: metadata.base_url,
        host: metadata.host,
        name: metadata.name,
        avatar: metadata.avatar,
        jira_id: metadata.id
      })

    {:ok, integration}
  end

  @doc """
  To be called, once user provides board_id and upcoming_tickets_jql via settings
  """
  def configure(integration_id, board_id, upcoming_tickets_jql) do
    settings = %{
      board_id: board_id,
      upcoming_tickets_jql: upcoming_tickets_jql
    }

    IntegrationsRepository.update_settings(integration_id, settings)
  end

  def list_upcoming_tickets(integration) do
    settings = integration.settings

    endpoint_url =
      "#{settings.host}/rest/agile/1.0/board/#{settings.board_id}/issue?jql=#{URI.encode(settings.upcoming_tickets_jql)}&fields=summary"

    token = get_token(integration)

    get_tickets(endpoint_url, token)
  end

  def list_in_progress_tickets(integration) do
    settings = integration.settings

    endpoint_url =
      "#{settings.host}/rest/agile/1.0/board/#{settings.board_id}/issue?jql=#{URI.encode(settings.inprogress_tickets_jql)}&fields=summary"

    token = get_token(integration)

    get_tickets(endpoint_url, token)
  end

  defp get_token_metadata(integration) do
    {:ok, response} =
      Finch.build(
        :get,
        "#{@api_atlassian}/oauth/token/accessible-resources",
        [
          {"Content-Type", "application/json"},
          {"Accept", "application/json"},
          {"Authorization", "Bearer #{get_token(integration)}}"}
        ]
      )
      |> Finch.request(PairDance.Finch)

    [payload] = Jason.decode!(response.body)

    id = payload["id"]
    name = payload["name"]
    url = payload["url"]
    host = "https://api.atlassian.com/ex/jira/#{id}"
    avatar = payload["avatarUrl"]
    scopes = payload["scopes"]

    %{
      id: id,
      name: name,
      base_url: url,
      host: host,
      avatar: avatar,
      scopes: scopes
    }
  end

  defp refresh_token_flow(refresh_token) do
    {:ok, response} =
      Finch.build(
        :post,
        @auth_atlassian,
        [
          {"Content-Type", "application/json"}
        ],
        Jason.encode!(%{
          "grant_type" => "refresh_token",
          "refresh_token" => refresh_token,
          "client_id" => Application.get_env(:pair_dance, :jira_client_id),
          "client_secret" => Application.get_env(:pair_dance, :jira_client_secret)
        })
      )
      |> Finch.request(PairDance.Finch)

    payload = Jason.decode!(response.body)

    %{
      refresh_token: payload["refresh_token"],
      access_token: payload["access_token"],
      access_token_expiry: token_expiry_date(payload["expires_in"])
    }
  end

  defp get_token(integration) do
    credentials = integration.credentials

    case has_token_expired(credentials.access_token_expiry) do
      true ->
        new_token_set = refresh_token_flow(credentials.refresh_token)
        IntegrationsRepository.update_settings(integration.id, new_token_set)
        new_token_set.access_token

      false ->
        credentials.access_token
    end
  end

  defp token_expiry_date(token_ttl) do
    DateTime.utc_now()
    |> DateTime.to_unix()
    |> Kernel.+(token_ttl)
  end

  defp has_token_expired(token_expiry_date) do
    time_in_seconds_now = DateTime.utc_now() |> DateTime.to_unix()
    token_expiry_date < time_in_seconds_now
  end

  defp get_tickets(endpoint, token) do
    {:ok, response} =
      Finch.build(
        :get,
        endpoint,
        [
          {"Authorization", "Bearer #{token}"},
          {"Accept", "application/json"},
          {"Content-Type", "application/json"}
        ]
      )
      |> Finch.request(PairDance.Finch)

    payload = Jason.decode!(response.body)

    case response do
      %{status: 200} ->
        Enum.map(payload["issues"], fn issue ->
          %{title: issue["fields"]["summary"], id: issue["key"]}
        end)

      _ ->
        []
    end
  end
end
