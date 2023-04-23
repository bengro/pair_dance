defmodule PairDanceWeb.PairingTableLive.Index do
  use PairDanceWeb, :live_view

  alias PairDance.Teams
  alias PairDance.Teams.Task

  @impl true
  def mount(%{"id" => team_id_str}, _session, socket) do
    { team_id, ""} = Integer.parse(team_id_str)
    socket_with_assigns =
      socket
      |> assign(:team_id, team_id)
      |> assign(:members, list_members())
      |> assign(:tasks, list_tasks())
      |> assign(:task, %Task{team_id: team_id})

    {:ok, socket_with_assigns}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Task")
  end

  defp list_members do
    Teams.list_members()
  end

  defp list_tasks do
    Teams.list_tasks()
  end

  @impl true
  def handle_event("create-task", %{}, socket) do
    {:noreply, socket}
  end
end
