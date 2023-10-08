defmodule PairDanceWeb.AppLive.SettingsPage.JiraIntegrationComponent do
  use PairDanceWeb, :live_component

  alias PairDance.Domain.Integration
  alias PairDance.Infrastructure.Integrations.EctoRepository, as: IntegrationRepository

  @impl true
  def update(assigns, socket) do
    team = assigns.team
    integration = IntegrationRepository.find_by_team_id(team.descriptor.id)

    socket =
      socket
      |> assign(:team, team)
      |> assign(:jira_client_id, Application.get_env(:pair_dance, :jira_client_id))
      |> assign(
        :jira_redirect_uri,
        URI.encode(Application.get_env(:pair_dance, :jira_redirect_uri))
      )
      |> assign(:integration, integration)
      |> assign_integration_settings(integration)

    {:ok, socket}
  end

  @impl true
  def handle_event(
        "save",
        %{
          "jira_integration_form" => %{"backlog_query" => backlog_query, "board_id" => board_id}
        },
        socket
      ) do
    changeset = Integration.changeset(board_id, backlog_query)
    jira_integration_form = jira_integration_form(board_id, backlog_query)
    integration = socket.assigns.integration

    case changeset.valid? do
      true ->
        {:ok, updated_integration} =
          IntegrationRepository.update_settings(
            integration.id,
            %{
              board_id: changeset.changes.board_id,
              backlog_query: changeset.changes.backlog_query
            }
          )

        assigns =
          socket
          |> assign(:jira_integration_form, jira_integration_form)
          |> assign(:integration, updated_integration)
          |> assign_integration_settings(integration)

        {:noreply, assigns}

      false ->
        errors =
          Map.merge(
            %{board_id: [], backlog_query: []},
            Ecto.Changeset.traverse_errors(changeset, &translate_error/1)
          )

        assigns =
          socket
          |> assign(:jira_integration_form, jira_integration_form)
          |> assign(:jira_integration_form_errors, errors)

        {:noreply, assigns}
    end
  end

  def handle_event("disconnect", _value, socket) do
    integration = socket.assigns.integration
    IntegrationRepository.delete(integration)

    socket =
      socket
      |> assign(:integration, nil)

    {:noreply, socket}
  end

  defp jira_integration_form(board_id, backlog_query) do
    Phoenix.HTML.FormData.to_form(Integration.changeset(board_id, backlog_query),
      as: "jira_integration_form"
    )
  end

  defp assign_integration_settings(socket, nil), do: socket

  defp assign_integration_settings(socket, %Integration{}) do
    socket
    |> assign(
      :jira_integration_form,
      jira_integration_form(
        socket.assigns.integration.settings.board_id,
        socket.assigns.integration.settings.backlog_query
      )
    )
    |> assign(:jira_integration_form_errors, %{board_id: [], backlog_query: []})
  end
end
