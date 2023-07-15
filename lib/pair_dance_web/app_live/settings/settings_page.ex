defmodule PairDanceWeb.AppLive.SettingsPage do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  @impl true
  def mount(%{"slug" => slug}, session, socket) do
    team = TeamRepository.find_by_slug?(slug)
    user = session["current_user"]

    assigns =
      socket
      |> assign(:team, team)
      |> assign(:current_user, user)
      |> assign(:page_title, "Settings")

    {:ok, assigns}
  end

  @impl true
  def handle_info({:team_changed, team}, socket) do
    IO.puts("handle team_changed in settings")
    {:noreply, assign(socket, :team, team)}
  end
end
