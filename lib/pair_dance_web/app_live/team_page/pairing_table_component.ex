defmodule PairDanceWeb.AppLive.TeamPage.PairingTableComponent do
  use PairDanceWeb, :live_component
  alias PairDance.Infrastructure.EventBus
  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  @impl true
  def update(assigns, socket) do
    team = assigns.team

    available_members =
      Enum.filter(team.members, fn member ->
        assigned =
          Enum.any?(team.assignments, fn assignment ->
            assignment.member.user.id == member.user.id
          end)

        !assigned and member.available == true
      end)

    unavailable_members =
      Enum.filter(team.members, fn member ->
        member.available == false
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
     assign(socket,
       available_members: available_members,
       unavailable_members: unavailable_members,
       current_tasks: current_tasks,
       team: team
     )}
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

    {:ok, updated_team} = TeamRepository.mark_member_available(team, member)

    EventBus.broadcast(updated_team.descriptor.id, %{ team: updated_team })

    {:noreply, assign(socket, team: updated_team)}
  end

  @impl true
  def handle_event("mark_member_unavailable", params, socket) do
    team = socket.assigns.team
    user_id = params["userId"]
    member = Enum.find(team.members, fn member -> member.user.id == user_id end)
    old_task_id = sanitise_task_id(params["oldTaskId"])

    if old_task_id != nil do
      %{team: team, member: member}
      |> unassign_from_task(old_task_id)
    end

    {:ok, updated_team} = TeamRepository.mark_member_unavailable(team, member)

    EventBus.broadcast(updated_team.descriptor.id, %{ team: updated_team, })
    {:noreply, assign(socket, team: updated_team)}
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
      {:ok, team} = TeamRepository.unassign_member_from_task(team, member, task)
      %{team: team, member: member}
    else
      %{team: team, member: member}
    end
  end

  defp assign_to_task(%{team: team, member: member}, task_id) do
    if task_id != nil do
      task = Enum.find(team.tasks, fn task -> task.id == task_id end)
      {:ok, team} = TeamRepository.assign_member_to_task(team, member, task)
      %{team: team, member: member}
    else
      %{team: team, member: member}
    end
  end
end
