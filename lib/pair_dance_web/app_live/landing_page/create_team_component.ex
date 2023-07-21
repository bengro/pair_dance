defmodule PairDanceWeb.AppLive.LandingPage.CreateTeamComponent do
  use PairDanceWeb, :live_component
  alias PairDance.Infrastructure.EventBus
  alias PairDance.Domain.Team

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.simple_form
        :let={f}
        for={%{}}
        as={:team}
        id="new-team-form"
        phx-target={@myself}
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="Team name" />
        <:actions>
          <.button data-qa="new-team-submit" phx-disable-with="Creating...">
            Add
          </.button>
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
    new_team = params["team"]["name"]
    current_user = socket.assigns.user
    {:ok, team} = Team.TeamService.new_team(new_team, current_user)
    EventBus.broadcast(%{team: team})
    {:noreply, push_navigate(socket, to: "/" <> team.descriptor.slug)}
  end
end
