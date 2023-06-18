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
  def handle_event("reposition", params, socket) do
    user_id = params["userId"]

    op =
      case params["to"]["task_id"] do
        nil -> :unassign
        _ -> :assign
      end

    task_id = String.to_integer(params["to"]["task_id"] || params["taskId"])

    team = socket.assigns.team
    member = Enum.find(team.members, fn member -> member.user.id == user_id end)
    task = Enum.find(team.tasks, fn task -> task.id == task_id end)

    {:ok, updated_team} =
      case op do
        :unassign ->
          assignment =
            Enum.find(team.assignments, fn a ->
              a.member.user.id == user_id && a.task.id == task.id
            end)

          EctoRepository.unassign_member_from_task(team, assignment)

        :assign ->
          EctoRepository.assign_member_to_task(team, %Assignment{task: task, member: member})
      end

    {:noreply, assign(socket, team: updated_team)}
  end
end
