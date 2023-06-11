defmodule PairDanceWeb.AppLive.TeamPage do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    team = TeamRepository.find_by_slug(slug)

    assigns =
      socket
      |> assign(:team, team)
      |> assign(:page_title, "Team #{team.name}")

    {:ok, assigns}
  end

  @impl true
  def handle_event("create-task", %{}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:team_changed, team}, socket) do
    {:noreply, assign(socket, :team, team)}
  end
end
