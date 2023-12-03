defmodule PairDanceWeb.AppLive.InsightsPage do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.Insights.Repository, as: WorkLogService
  alias PairDance.Domain.Insights.Calendar

  import PairDanceWeb.AppLive.InsightsPage.Components

  @impl true
  def mount(%{"slug" => slug}, session, socket) do
    user = session["current_user"]
    team = TeamRepository.find_by_slug?(slug)

    {:ok, tasks_member_was_involved} = WorkLogService.get_assigned_tasks_by_user(user, team)
    calendar = Calendar.build(tasks_member_was_involved)

    {:ok, all_assignments} = WorkLogService.get_assignments_by_team(team)
    heatmap = PairDance.Domain.Insights.Heatmap.calculate_heatmap(all_assignments)

    assigns =
      socket
      |> assign(:current_user, user)
      |> assign(:team, team)
      |> assign(:calendar, calendar)
      |> assign(:heatmap, heatmap)
      |> assign(:page_title, "Insights")

    {:ok, assigns}
  end
end
