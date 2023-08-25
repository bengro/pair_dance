defmodule PairDanceWeb.AppLive.InsightsPage do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.Insights.EctoService, as: WorkLogService
  alias PairDance.Domain.Insights.Calendar

  import PairDanceWeb.AppLive.InsightsPage.Components

  @impl true
  def mount(%{"slug" => slug}, session, socket) do
    user = session["current_user"]
    team = TeamRepository.find_by_slug?(slug)

    {:ok, assigned_tasks} = WorkLogService.get_assigned_tasks_by_user(user, team)
    task_summary = PairDance.Domain.Insights.AssignedTaskSummary.build(assigned_tasks)
    calendar = Calendar.build(assigned_tasks)

    assigns =
      socket
      |> assign(:current_user, user)
      |> assign(:team, team)
      |> assign(:activities, task_summary)
      |> assign(:calendar, calendar)
      |> assign(:page_title, "Insights")

    {:ok, assigns}
  end
end
