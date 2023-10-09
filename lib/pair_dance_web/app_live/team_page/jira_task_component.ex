defmodule PairDanceWeb.AppLive.TeamPage.JiraTaskComponent do
  use PairDanceWeb, :live_component
  alias PairDance.Infrastructure.Jira.JiraService
  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.EventBus
  alias PairDance.Domain.Team

  @impl true
  def update(assigns, socket) do
    team_id = assigns[:team_id]
    jira_integration = assigns[:integration]

    case jira_integration do
      nil ->
        assigns =
          socket
          |> assign(:jira_tickets, [])
          |> assign(:team_id, team_id)

        {:ok, assigns}

      _ ->
        jira_tickets = JiraService.list_upcoming_tickets(jira_integration)

        assigns =
          socket
          |> assign(:jira_tickets, jira_tickets)
          |> assign(:team_id, team_id)

        {:ok, assigns}
    end
  end

  @impl true
  def handle_event("create_task", %{"task_name" => task_name}, socket) do
    team_id = socket.assigns.team_id

    {:ok, team} =
      TeamRepository.add_task(
        # TODO: add_task should take just the team_id
        %Team{members: [], tasks: [], assignments: [], descriptor: %{id: team_id}},
        task_name
      )

    EventBus.broadcast(team_id, %{team: team})

    {:noreply, socket}
  end
end
