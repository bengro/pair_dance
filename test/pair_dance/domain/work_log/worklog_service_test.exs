defmodule PairDance.Domain.WorkLog.ServiceTest do
  use PairDance.DataCase

  alias PairDance.Domain.WorkLog.Service

  import PairDance.TeamsFixtures

  test "returns assignments by user" do
    team =
      create_team(%{
        member_names: ["ana"],
        task_names: ["refactor fedramp", "closed beta"]
      })
      |> create_assignment("refactor fedramp", "ana")
      |> create_assignment("closed beta", "ana")

    task_names =
      Service.get_task_history(Enum.at(team.members, 0).user, team)
      |> Enum.map(fn assignment -> assignment.task.name end)

    assert ["refactor fedramp", "closed beta"] = task_names
  end

  test "returns past assignments" do
    team =
      create_team(%{
        member_names: ["ana"],
        task_names: ["fedramp"]
      })
      |> create_assignment("fedramp", "ana")
      |> delete_assignment("fedramp", "ana")

    assignments =
      Service.get_task_history(Enum.at(team.members, 0).user, team)

    assert length(assignments) == 1
  end

  test "scopes assignments to the team provided" do
    _team1 = create_team(%{ member_names: ["ana"], task_names: ["task"] })
      |> create_assignment("task", "ana")
    team2 = create_team(%{ member_names: ["ana"], task_names: [] })

    assignments = Service.get_task_history(Enum.at(team2.members, 0).user, team2)

    assert length(assignments) == 0
  end
end
