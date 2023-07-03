defmodule PairDance.Domain.WorkLog.ServiceTest do
  use PairDance.DataCase

  import PairDance.TeamsFixtures

  test "return all assignments by user" do
    team =
      create_team(%{
        member_names: ["ana"],
        task_names: ["refactor fedramp", "closed beta"]
      })
      |> create_assignment("refactor fedramp", "ana")
      |> create_assignment("closed beta", "ana")

    task_names =
      PairDance.Domain.WorkLog.Service.get_task_history(Enum.at(team.members, 0).user, team)
      |> Enum.map(fn assignment -> assignment.task.name end)

    assert ["refactor fedramp", "closed beta"] = task_names
  end
end
