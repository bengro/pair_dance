defmodule PairDanceWeb.PairingTableLive.Index do
  use PairDanceWeb, :live_view

  alias PairDance.Teams

  @impl true
  def mount(_params, _session, socket) do
    socket_with_assigns =
      socket
      |> assign(:members, list_members())
      |> assign(:tasks, list_tasks())

    {:ok, socket_with_assigns}
  end

  defp list_members do
    Teams.list_members()
  end

  defp list_tasks do
    Teams.list_tasks()
  end
end
