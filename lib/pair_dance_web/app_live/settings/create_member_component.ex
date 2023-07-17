defmodule PairDanceWeb.AppLive.Settings.CreateMemberComponent do
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
      >
        <.input field={{f, :email}} type="email" label="Add your team members by E-Mail." />
        <:actions>
          <.button phx-disable-with="Adding...">
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

  def handle_event("save", %{"user" => user}, socket) do
    team = InviteService.invite(socket.assigns.team, user["email"])
    send(self(), {:team_changed, team})
    {:noreply, assign(socket, team: team)}
  end
end
