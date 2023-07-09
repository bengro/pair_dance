defmodule PairDanceWeb.AppLive.LandingPage do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.WorkLog.EctoService, as: WorkLogService

  @impl true
  def mount(_params, session, socket) do
    user = session["current_user"]

    assigns =
      case user do
        nil ->
          socket
          |> assign(:current_user, user)
          |> assign(:page_title, "Welcome")

        _ ->
          all_teams = TeamRepository.find_by_member(user.id)

          all_activities =
            Enum.map(all_teams, fn team_descriptor ->
              team = TeamRepository.find(team_descriptor.id)
              {:ok, task_history} = WorkLogService.get_assigned_tasks_by_user(user, team)
              %{team: team, task_history: task_history}
            end)

          socket
          |> assign(:current_user, user)
          |> assign(:my_teams, all_teams)
          |> assign(:all_activities, all_activities)
          |> assign(:page_title, "Welcome")
      end

    {:ok, assigns}
  end
end
