defmodule PairDanceWeb.AppLive.TeamMembersPage do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    team = TeamRepository.find_by_slug?(slug)

    if team == nil do
      assigns =
        socket
        |> assign(:error, "not found")
        |> assign(:page_title, "Sorry, not found")

      {:ok, assigns}
    else
      assigns =
        socket
        |> assign(:team, team)
        |> assign(:page_title, "Team Members")

      {:ok, assigns}
    end
  end

  @impl true
  def handle_info({:team_changed, team}, socket) do
    {:noreply, assign(socket, :team, team)}
  end
end
