defmodule PairDanceWeb.AppLive.TeamPage do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.EventBus
  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.User.EctoRepository, as: UserRepository
  alias PairDance.Infrastructure.Integrations.EctoRepository, as: IntegrationRepository

  @impl true
  def mount(%{"slug" => slug}, session, socket) do
    team = TeamRepository.find_by_slug?(slug)
    session_user = session["current_user"]

    EventBus.subscribe(team.descriptor.id)

    user = UserRepository.find_by_id(session_user.id) |> mark_current_team_as_last_active(team)
    jira_integration = IntegrationRepository.find_by_team_id(team.descriptor.id)

    assigns =
      socket
      |> assign(:current_user, user)
      |> assign(:team, team)
      |> assign(:jira_integration, jira_integration)
      |> assign(:page_title, "Team #{team.descriptor.name}")

    {:ok, assigns}
  end

  @impl true
  def handle_info(payload, socket) do
    case payload do
      %{team: team, current_user: current_user} ->
        {:noreply, assign(socket, :team, team)}

      %{team: team} ->
        {:noreply, assign(socket, :team, team)}
    end
  end

  defp mark_current_team_as_last_active(user, team) do
    if user.last_active_team_id != team.descriptor.id do
      {:ok, user} = UserRepository.update(user, %{last_active_team_id: team.descriptor.id})
      user
    else
      user
    end
  end
end
