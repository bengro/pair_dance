defmodule PairDanceWeb.AppLive.InsightsPage do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.WorkLog.EctoService, as: WorkLogService

  @impl true
  def mount(%{"slug" => slug}, session, socket) do
    team = TeamRepository.find_by_slug?(slug)
    user = session["current_user"]

    {:ok, assigned_tasks} = WorkLogService.get_assigned_tasks_by_user(user, team)
    task_summary = PairDance.Domain.WorkLog.AssignedTaskSummary.build(assigned_tasks)

    assigns =
      socket
      |> assign(:current_user, user)
      |> assign(:team, team)
      |> assign(:activities, task_summary)
      |> assign(:page_title, "Insights")

    {:ok, assigns}
  end
end
