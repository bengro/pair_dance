defmodule PairDanceWeb.AppLive.TeamPage.JiraTicketComponent do
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
        {:ok, tasks} = TeamRepository.get_tasks(team_id)

        external_ids_of_tasks_in_flight =
          Enum.map(tasks, fn task -> task.descriptor.external_id end)

        jira_tickets = JiraService.list_upcoming_tickets(jira_integration)

        assigns =
          socket
          |> assign(:jira_tickets, tickets_to_show(jira_tickets, external_ids_of_tasks_in_flight))
          |> assign(:team_id, team_id)

        {:ok, assigns}
    end
  end

  @impl true
  def handle_event(
        "create_task",
        %{"ticket_name" => task_name, "ticket_id" => ticket_id},
        socket
      ) do
    team_id = socket.assigns.team_id

    {:ok, team} =
      TeamRepository.add_task(
        # TODO: add_task should take just the team_id
        %Team{members: [], tasks: [], assignments: [], descriptor: %{id: team_id}},
        task_name,
        ticket_id
      )

    EventBus.broadcast(team_id, %{team: team})

    external_ids_of_tasks_in_flight = Enum.map(team.tasks, fn task -> task.external_id end)

    {:noreply,
     socket
     |> assign(
       :jira_tickets,
       tickets_to_show(socket.assigns.jira_tickets, external_ids_of_tasks_in_flight)
     )}
  end

  defp tickets_to_show(jira_tickets, tasks_by_external_id_in_flight) do
    Enum.filter(jira_tickets, fn ticket ->
      !Enum.member?(tasks_by_external_id_in_flight, ticket.id)
    end)
  end
end
