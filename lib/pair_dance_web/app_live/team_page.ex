defmodule PairDanceWeb.AppLive.TeamPage do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.EventBus
  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.User.EctoRepository, as: UserRepository
  alias PairDance.Infrastructure.Integrations.EctoRepository, as: IntegrationRepository
  alias PairDance.Infrastructure.Jira.JiraService

  @impl true
  def mount(%{"slug" => slug}, session, socket) do
    team = TeamRepository.find_by_slug?(slug)
    EventBus.subscribe(team.descriptor.id)

    session_user = session["current_user"]
    user = UserRepository.find_by_id(session_user.id) |> mark_current_team_as_last_active(team)
    jira_integration = IntegrationRepository.find_by_team_id(team.descriptor.id)

    team =
      case jira_integration do
        nil ->
          team

        _ ->
          jira_tickets = JiraService.list_in_progress_tickets(jira_integration)
          create_tasks_from_jira(team, jira_tickets)
      end

    assigns =
      socket
      |> assign(:current_user, user)
      |> assign(:team, team)
      |> assign(:jira_integration, jira_integration)
      |> assign(:page_title, "Team #{team.descriptor.name}")

    {:ok, assigns}
  end

  @impl true
  def handle_info(%{team: team}, socket) do
    {:noreply, assign(socket, :team, team)}
  end

  defp mark_current_team_as_last_active(user, team) do
    if user.last_active_team_id != team.descriptor.id do
      {:ok, user} = UserRepository.update(user, %{last_active_team_id: team.descriptor.id})
      user
    else
      user
    end
  end

  defp create_tasks_from_jira(team, jira_tickets) do
    task_external_ids = Enum.map(team.tasks, fn task -> task.external_id end)

    jira_tickets_not_on_pairing_board =
      Enum.filter(jira_tickets, fn ticket ->
        !Enum.member?(task_external_ids, ticket.id)
      end)

    Enum.each(jira_tickets_not_on_pairing_board, fn ticket_to_be_imported ->
      TeamRepository.add_task(team, ticket_to_be_imported.title, ticket_to_be_imported.id)
    end)

    TeamRepository.find(team.descriptor.id)
  end
end
