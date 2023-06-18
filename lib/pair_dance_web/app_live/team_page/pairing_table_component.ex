defmodule PairDanceWeb.AppLive.TeamPage.PairingTableComponent do
  use PairDanceWeb, :live_component

  alias PairDance.Domain.Team.Assignment
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

    {:ok, team} =
      if old_task_id != nil do
        assignment =
          Enum.find(team.assignments, fn a ->
            a.member.user.id == user_id && a.task.id == old_task_id
          end)

        EctoRepository.unassign_member_from_task(team, assignment)
      else
        {:ok, team}
      end

    {:ok, team} =
      if new_task_id != nil do
        task = Enum.find(team.tasks, fn task -> task.id == new_task_id end)
        EctoRepository.assign_member_to_task(team, %Assignment{task: task, member: member})
      else
        {:ok, team}
      end

    {:noreply, assign(socket, team: team)}
  end

  defp sanitise_task_id(task_id) do
    case task_id do
      nil -> nil
      _ -> String.to_integer(task_id)
    end
  end
end
