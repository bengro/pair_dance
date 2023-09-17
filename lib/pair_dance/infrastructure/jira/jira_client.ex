defmodule PairDance.Infrastructure.Jira.JiraClient do
  @behaviour PairDance.Infrastructure.Jira.Operations
  alias PairDance.Infrastructure.Integrations.EctoRepository, as: IntegrationsRepository

  alias PairDance.Domain.Integration

  @token_endpoint "https://auth.atlassian.com/oauth/token"

  def connect(auth_code) do
    refresh_token = get_refresh_token(auth_code)
    host = get_host(refresh_token)
    settings = %{refresh_token: refresh_token, host: host}

    IntegrationsRepository.create(settings)
  end

  def configure(integration_id, board_id, backlog_query) do
    IntegrationsRepository.update_settings(integration_id, %{
      board_id: board_id,
      backlog_query: backlog_query
    })
  end

  def list_upcoming_tickets(integration_id) do
    %Integration{settings: settings, credentials: credentials} =
      IntegrationsRepository.find_by_id(integration_id)

    url =
      "#{settings.host}/rest/agile/1.0/board/#{settings.board_id}/issue?jql=#{settings.backlog_query}"

    access_token = get_access_token(credentials.refresh_token)

    {:ok, response} =
      Finch.build(
        :get,
        url,
        [
          {"Authorization", "Bearer #{access_token}"},
          {"Accept", "application/json"}
        ]
      )
      |> Finch.request(PairDance.Finch)

    Jason.decode!(response.body)["issues"]
  end

  defp get_access_token(refresh_token) do
    {:ok, response} =
      Finch.build(
        :post,
        @token_endpoint,
        [
          {"Content-Type", "application/json"},
          {"Accept", "application/json"}
        ],
        Jason.encode!(%{
          "grant_type" => "refresh_token",
          "refresh_token" => refresh_token,
          "client_id" => Application.get_env(:pair_dance, :jira_client_id),
          "client_secret" => Application.get_env(:pair_dance, :jira_client_secret)
        })
      )
      |> Finch.request(PairDance.Finch)

    Jason.decode!(response.body)["access_token"]
  end

  defp get_refresh_token(auth_code) do
    {:ok, response} =
      Finch.build(
        :post,
        @token_endpoint,
        [
          {"Content-Type", "application/json"},
          {"Accept", "application/json"}
        ],
        Jason.encode!(%{
          "grant_type" => "authorization_code",
          "code" => auth_code,
          "client_id" => Application.get_env(:pair_dance, :jira_client_id),
          "client_secret" => Application.get_env(:pair_dance, :jira_client_secret)
        })
      )
      |> Finch.request(PairDance.Finch)

    Jason.decode!(response.body)["refresh_token"]
  end

  defp get_host(_refresh_token) do
    "https://api.atlassian.com/ex/jira/7ff3b24b-06bd-4c29-bbc7-e1ff95ae5076/"
  end
end
