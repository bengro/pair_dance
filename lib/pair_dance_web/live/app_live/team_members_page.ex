defmodule PairDanceWeb.AppLive.TeamMembersPage do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    team = TeamRepository.find_by_slug(slug)

    if team == nil do
      {:ok, assign(socket, :error, "not found")}
    else
      {:ok, assign(socket, :team, team)}
    end
  end

  @impl true
  def handle_info({:team_changed, team}, socket) do
    {:noreply, assign(socket, :team, team)}
  end

end
