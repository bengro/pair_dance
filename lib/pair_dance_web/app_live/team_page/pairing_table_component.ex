defmodule PairDanceWeb.AppLive.TeamPage.PairingTableComponent do
  use PairDanceWeb, :live_component

  alias PairDance.Infrastructure.Team.EctoRepository

  @impl true
  def update(assigns, socket) do
    team = assigns.team

    available_members =
      Enum.filter(team.members, fn member ->
        assigned =
          Enum.any?(team.assignments, fn assignment ->
            assignment.member.user.id == member.user.id
          end)

        !assigned
      end)

    current_tasks =
      Enum.map(team.tasks, fn task ->
        %{
          id: task.id,
          name: task.name,
          assignees:
            Enum.filter(team.assignments, fn assignment -> assignment.task.id == task.id end)
            |> Enum.map(fn assignment -> assignment.member end)
        }
      end)

    {:ok,
     assign(socket, available_members: available_members, current_tasks: current_tasks, team: team)}
  end

  @impl true
  def handle_event("reassign", params, socket) do
    team = socket.assigns.team
    user_id = params["userId"]
    member = Enum.find(team.members, fn member -> member.user.id == user_id end)
    old_task_id = sanitise_task_id(params["oldTaskId"])
    new_task_id = sanitise_task_id(params["newTaskId"])

    %{team: team} =
      %{team: team, member: member}
      |> unassign_from_task(old_task_id)
      |> assign_to_task(new_task_id)

    {:noreply, assign(socket, team: team)}
  end

  defp sanitise_task_id(task_id) do
    case task_id do
      nil -> nil
      _ -> String.to_integer(task_id)
    end
  end

  defp unassign_from_task(%{team: team, member: member}, task_id) do
    if task_id != nil do
      task = Enum.find(team.tasks, fn task -> task.id == task_id end)
      {:ok, team} = EctoRepository.unassign_member_from_task(team, member, task)
      %{team: team, member: member}
    else
      %{team: team, member: member}
    end
  end

  defp assign_to_task(%{team: team, member: member}, task_id) do
    if task_id != nil do
      task = Enum.find(team.tasks, fn task -> task.id == task_id end)
      {:ok, team} = EctoRepository.assign_member_to_task(team, member, task)
      %{team: team, member: member}
    else
      %{team: team, member: member}
    end
  end
end
