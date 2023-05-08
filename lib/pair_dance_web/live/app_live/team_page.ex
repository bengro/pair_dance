defmodule PairDanceWeb.PairingTableLive.Index do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.EctoTeamRepository, as: TeamRepository

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    team = TeamRepository.find_by_slug(slug)
    if team == nil do
      {:ok, assign(socket, :error, "not found")}
    else
      socket_with_assigns =
        socket
        |> assign(:team, team)

      {:ok, socket_with_assigns}
    end
  end

  @impl true
  def render( %{ error: "not found"} = assigns) do
    ~H"""
      <div>not found</div>
    """
  end
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

    """
  end

  @impl true
  def handle_event("create-task", %{}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info({:team_changed, team}, socket) do
    {:noreply, socket |> assign(:team, team) |> assign(:tasks, team.tasks)}
  end
end
