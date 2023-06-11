defmodule PairDanceWeb.AppLive.TeamPage.ListComponent do
  use PairDanceWeb, :live_component

  def handle_event("reposition", params, socket) do
    # Put your logic here to deal with the changes to the list order
    # and persist the data
    IO.inspect(params)
    {:noreply, socket}
  end

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
