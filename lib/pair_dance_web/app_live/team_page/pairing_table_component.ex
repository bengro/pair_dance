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

    # [%{id: "", name: "", assignees: []}]

    {:ok,
     assign(socket, available_members: available_members, current_tasks: current_tasks, team: team)}
  end

  @impl true
  def handle_event("reposition", params, socket) do
    IO.puts("member assigned")
    IO.inspect(params)
    user_id = params["userId"]
    task_id = String.to_integer(params["to"]["task_id"])
    team = socket.assigns.team
    task = Enum.find(team.tasks, fn task -> task.id == task_id end)
    member = Enum.find(team.members, fn member -> member.user.id == user_id end)

    {:ok, updated_team} =
      EctoRepository.assign_member_to_task(team, %Assignment{task: task, member: member})

    {:noreply, assign(socket, team: updated_team)}
  end
end
