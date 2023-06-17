defmodule PairDanceWeb.AppLive.TeamPage.PairingTableComponent do
  use PairDanceWeb, :live_component

  @impl true
  def update(assigns, socket) do
    team = assigns.team

    list = [
      %{name: "Bread", id: 1, position: 1, status: :in_progress},
      %{name: "Butter", id: 2, position: 2, status: :in_progress},
      %{name: "Milk", id: 3, position: 3, status: :in_progress},
      %{name: "Bananas", id: 4, position: 4, status: :in_progress},
      %{name: "Eggs", id: 5, position: 5, status: :in_progress}
    ]

    {:ok, assign(socket, shopping_list: list, team: team)}
  end
end
