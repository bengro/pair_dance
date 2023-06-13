defmodule PairDanceWeb.AppLive.AccountPage.CreateTeamComponent do
  use PairDanceWeb, :live_component

  alias PairDance.Domain.Team

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        :let={f}
        for={:team}
        id="new-team-form"
        phx-target={@myself}
        phx-submit="save"
        phx-change="validate"
      >
        <.input field={{f, :name}} type="text" label="name" />
        <:actions>
          <.button phx-disable-with="Creating...">Create</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(assigns, socket) do
    user = assigns[:user]
    {:ok, assign(socket, :user, user)}
  end

  @impl true
  def handle_event("validate", _, socket) do
    {:noreply, socket}
  end

  def handle_event("save", params, socket) do
    {:ok, team} = Team.TeamService.new_team(params["team"]["name"], socket.assigns.user)
    send(self(), {:team_changed, team})
    {:noreply, push_navigate(socket, to: "/" <> team.slug)}
  end
end
