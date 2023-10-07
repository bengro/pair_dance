defmodule PairDanceWeb.AppLive.TeamPage.JiraTaskComponent do
  use PairDanceWeb, :live_component
  alias PairDance.Infrastructure.Jira.JiraService
  alias PairDance.Infrastructure.Integrations.EctoRepository, as: IntegrationRepository

  @impl true
  def update(assigns, socket) do
    team = assigns[:team]

    jira_integration = IntegrationRepository.find_by_team_id(team.descriptor.id)

    case jira_integration do
      nil ->
        assigns =
          socket
          |> assign(:jira_tickets, [])

        {:ok, assigns}

      _ ->
        jira_tickets = JiraService.list_upcoming_tickets(jira_integration)

        assigns =
          socket
          |> assign(:jira_tickets, jira_tickets)

        {:ok, assigns}
    end
  end
end
