defmodule PairDanceWeb.AppLive.TeamPage do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.EventBus
  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  @impl true
  def mount(%{"slug" => slug}, session, socket) do
    EventBus.subscribe()

    user = session["current_user"]
    team = TeamRepository.find_by_slug?(slug)

    assigns =
      socket
      |> assign(:current_user, user)
      |> assign(:team, team)
      |> assign(:page_title, "Team #{team.descriptor.name}")

    {:ok, assigns}
  end

  @impl true
  def handle_event("create-task", %{}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("delete_task", %{"task_id" => task_id}, socket) do
    team = socket.assigns.team
    task = Enum.find(team.tasks, fn task -> task.id == String.to_integer(task_id) end)

    {:ok, updated_team} = TeamRepository.delete_task(team, task)
    EventBus.broadcast(%{team: updated_team})

    {:noreply,
     socket
     |> assign(:team, updated_team)}
  end

  @impl true
  @doc """
  Handler receives broadcasts from various place where team state is updated. E.g. rotations changed, task added/deleted.
  It then checks whether the event is relevant for the currently viewed team page. If so, it updates the team state.
  """
  def handle_info(%{team: team}, socket) do
    if team.descriptor.id == socket.assigns.team.descriptor.id do
      {:noreply, assign(socket, :team, team)}
    else
      {:noreply, socket}
    end
  end
end
