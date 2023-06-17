defmodule PairDanceWeb.AppLive.TeamPage.ListComponent do
  use PairDanceWeb, :live_component

  def handle_event("reposition", params, socket) do
    {:noreply, socket}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
