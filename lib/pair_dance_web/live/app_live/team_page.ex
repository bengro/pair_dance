defmodule PairDanceWeb.PairingTableLive.Index do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    team = TeamRepository.find_by_slug(slug)
    {:ok, assign(socket, :team, team)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h2>
      Team members:
    </h2>
    <ul>
      <%= for member <- @team.members do %>
        <li><%= member.user.email %></li>
      <% end %>
    </ul>

    <h2>
      Tasks:
    </h2>
    <ul>
      <%= for task <- @team.tasks do %>
        <li><%= task.name %></li>
      <% end %>
    </ul>

    <.live_component
      id={1}
      module={PairDanceWeb.AppLive.CreateTaskComponent}
      team={@team}
      action={:new}
    />

    <.live_component id="1" module={PairDanceWeb.ShoppingListComponent} />
    """
  end

  @impl true
  def handle_event("create-task", %{}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:team_changed, team}, socket) do
    {:noreply, assign(socket, :team, team)}
  end
end
