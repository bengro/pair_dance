defmodule PairDanceWeb.AppLive.AddMemberForm do
  use PairDanceWeb, :live_component

  alias PairDance.Domain.TeamInviteService

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        :let={f}
        for={:user}
        id="add-member-form"
        phx-target={@myself}
        phx-submit="save"
        phx-change="validate"
      >
        <.input field={{f, :email}} type="email" label="email" />
        <:actions>
          <.button phx-disable-with="Adding...">Add</.button>
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
    team = TeamInviteService.invite(socket.assigns.team, user["email"])
    send(self(), {:team_changed, team})
    {:noreply, assign(socket, team: team)}
  end
end
