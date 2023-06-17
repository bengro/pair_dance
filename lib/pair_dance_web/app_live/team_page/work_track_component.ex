defmodule PairDanceWeb.AppLive.TeamPage.WorkTrackComponent do
  use PairDanceWeb, :live_component

  def handle_event("reposition", _params, socket) do
    {:noreply, socket}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
