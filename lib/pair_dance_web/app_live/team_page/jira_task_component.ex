defmodule PairDanceWeb.AppLive.TeamPage.JiraTaskComponent do
  use PairDanceWeb, :live_component
  alias PairDance.Infrastructure.Jira.JiraService
  alias PairDance.Infrastructure.Integrations.EctoRepository, as: IntegrationRepository
  alias PairDance.Infrastructure.EventBus
  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  @impl true
  def update(assigns, socket) do
    team = assigns[:team]
    jira_integration = assigns[:integration]

    case jira_integration do
      nil ->
        assigns =
          socket
          |> assign(:jira_tickets, [])
          |> assign(:team, team)

        {:ok, assigns}

      _ ->
        jira_tickets = JiraService.list_upcoming_tickets(jira_integration)

        assigns =
          socket
          |> assign(:jira_tickets, jira_tickets)
          |> assign(:team, team)

        {:ok, assigns}
    end
  end

  @impl true
  def handle_event("create_task", %{"task_name" => task_name}, socket) do
    {:ok, team} = TeamRepository.add_task(socket.assigns.team, task_name)
    EventBus.broadcast(%{team: team})

    {:noreply, socket |> assign(:team, team)}
  end
end
