defmodule PairDanceWeb.PairingTableLive.Index do
  use PairDanceWeb, :live_view

  alias PairDance.Teams

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :members, list_members())}
  end

  defp list_members do
    Teams.list_members()
  end
end
