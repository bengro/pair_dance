defmodule PairDanceWeb.PairingTableLive.Index do
  use PairDanceWeb, :live_view

  alias PairDance.Teams
  alias PairDance.Teams.Task

  @impl true
  def mount(%{"id" => team_id_str}, _session, socket) do
    { team_id, ""} = Integer.parse(team_id_str)
    team = get_team(team_id)
    if team == nil do
      {:ok, assign(socket, :error, "not found")}
    else
      socket_with_assigns =
        socket
        |> assign(:team_id, team_id)
        |> assign(:members, Teams.list_members(team_id))
        |> assign(:tasks, Teams.list_tasks(team_id))
        |> assign(:task, %Task{team_id: team_id})

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
    <%= for member <- @members do %>
    <li><%= member.name %></li>
    <% end %>
    </ul>

    <h2>
    Tasks:
    </h2>
    <ul>
    <%= for task <- @tasks do %>
    <li><%= task.name %></li>
    <% end %>
    </ul>

    <.live_component
    id={1}
    module={PairDanceWeb.AppLive.CreateTaskComponent}
    team_id={1}
    task={@task}
    action={:new}
    />

    """
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
  end

  defp get_team(team_id) do
    Teams.get_team(team_id)
  end

  @impl true
  def handle_event("create-task", %{}, socket) do
    {:noreply, socket}
  end
end
