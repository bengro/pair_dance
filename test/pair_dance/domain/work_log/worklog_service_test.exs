defmodule PairDance.Domain.WorkLog.ServiceTest do
  use PairDance.DataCase

  alias PairDance.Domain.WorkLog.Service

  import PairDance.TeamsFixtures

  describe "get_assignments_by_user" do
    test "returns assignments by user" do
      team =
        create_team(%{
          member_names: ["ana"],
          task_names: ["refactor fedramp", "closed beta"]
        })
        |> create_assignment("refactor fedramp", "ana")
        |> create_assignment("closed beta", "ana")

      task_names =
        Service.get_assignments_by_user(Enum.at(team.members, 0).user, team)
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

      assignments = Service.get_assignments_by_user(Enum.at(team.members, 0).user, team)

      assert length(assignments) == 1
    end

    test "scopes assignments to the team provided" do
      _team1 =
        create_team(%{member_names: ["ana"], task_names: ["task"]})
        |> create_assignment("task", "ana")

      team2 = create_team(%{member_names: ["ana"], task_names: []})

      assignments = Service.get_assignments_by_user(Enum.at(team2.members, 0).user, team2)

      assert length(assignments) == 0
    end

    test "returns a task multiple times when reassigned" do
      team =
        create_team(%{
          member_names: ["ana"],
          task_names: ["fedramp"]
        })
        |> create_assignment("fedramp", "ana")
        |> delete_assignment("fedramp", "ana")
        |> create_assignment("fedramp", "ana")

      assignments = Service.get_assignments_by_user(Enum.at(team.members, 0).user, team)

      assert length(assignments) == 2
    end
  end

  describe "get_assignments_by_task" do
    test "returns all assignments of a task" do
      team =
        create_team(%{
          member_names: ["ana", "bob"],
          task_names: ["fedramp", "UI"]
        })
        |> create_assignment("fedramp", "ana")
        |> delete_assignment("fedramp", "ana")
        |> create_assignment("fedramp", "bob")
        |> create_assignment("UI", "bob")

      assignments = Service.get_assignments_by_task(Enum.at(team.tasks, 0))

      assert length(assignments) == 2

      users_assigned_to_task =
        Enum.map(assignments, fn assignment -> assignment.member.user.name end)

      assert users_assigned_to_task == ["ana", "bob"]
    end
  end
end
