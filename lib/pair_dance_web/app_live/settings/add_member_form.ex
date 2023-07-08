defmodule PairDanceWeb.AppLive.Settings.AddMemberForm do
  use PairDanceWeb, :live_component

  alias PairDance.Domain.Team.InviteService

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        :let={f}
        for={%{}}
        as={:user}
        id="add-member-form"
        phx-target={@myself}
        phx-submit="save"
        phx-change="validate"
      >
        <.input field={{f, :email}} type="email" label="Add your team members by E-Mail." />
        <:actions>
          <.button
            class="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
            phx-disable-with="Adding..."
          >
            Add
          </.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    team = assigns[:team]
    {:ok, assign(socket, :team, team)}
  end

  @impl true
  def handle_event("validate", _, socket) do
    {:noreply, socket}
  end

  def handle_event("save", %{"user" => user}, socket) do
    team = InviteService.invite(socket.assigns.team, user["email"])
    send(self(), {:team_changed, team})
    {:noreply, assign(socket, team: team)}
  end
end
