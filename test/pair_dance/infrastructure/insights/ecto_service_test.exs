defmodule PairDance.Domain.Insights.RepoTest do
  use PairDance.DataCase

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.Insights.EctoService, as: InsightService

  import PairDance.TeamsFixtures

  describe "get_assigned_tasks_by_user" do
    test "returns assignments by user" do
      team =
        create_team(%{
          member_names: ["ana"],
          task_names: ["refactor fedramp", "closed beta"]
        })
        |> create_assignment("refactor fedramp", "ana")
        |> create_assignment("closed beta", "ana")

      {:ok, assigned_tasks} =
        InsightService.get_assigned_tasks_by_user(Enum.at(team.members, 0).user, team)

      task_names =
        assigned_tasks
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

      {:ok, assignments} =
        InsightService.get_assigned_tasks_by_user(Enum.at(team.members, 0).user, team)

      assert length(assignments) == 1
    end

    test "scopes assignments to the team provided" do
      _team1 =
        create_team(%{member_names: ["ana"], task_names: ["task"]})
        |> create_assignment("task", "ana")

      team2 = create_team(%{member_names: ["ana"], task_names: []})

      {:ok, assignments} =
        InsightService.get_assigned_tasks_by_user(Enum.at(team2.members, 0).user, team2)

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

      {:ok, assignments} =
        InsightService.get_assigned_tasks_by_user(Enum.at(team.members, 0).user, team)

      assert length(assignments) == 2
    end

    test "returns assignments after tasks are deleted" do
      team =
        create_team(%{
          member_names: ["ana"],
          task_names: ["fedramp"]
        })
        |> create_assignment("fedramp", "ana")

      TeamRepository.delete_task(team, Enum.at(team.tasks, 0))

      {:ok, assignments} =
        InsightService.get_assigned_tasks_by_user(Enum.at(team.members, 0).user, team)

      assert length(assignments) == 1
    end
  end

  describe "get_assigned_members_by_task" do
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

      {:ok, assignments} = InsightService.get_assigned_members_by_task(Enum.at(team.tasks, 0))

      assert length(assignments) == 2

      users_assigned_to_task =
        Enum.map(assignments, fn assignment -> assignment.member.user.name end)

      assert length(users_assigned_to_task) == 2
      assert Enum.member?(users_assigned_to_task, "ana")
      assert Enum.member?(users_assigned_to_task, "bob")
    end
  end

  describe "get_assignments_by_team" do
    test "returns all assignments of a team" do
      create_team(%{
        member_names: ["ana", "bob"],
        task_names: ["fedramp", "UI"]
      })
      |> create_assignment("fedramp", "ana")

      team =
        create_team(%{
          member_names: ["ana", "bob"],
          task_names: ["fedramp", "UI"]
        })
        |> create_assignment("fedramp", "ana")
        |> delete_assignment("fedramp", "ana")
        |> create_assignment("fedramp", "bob")
        |> create_assignment("UI", "bob")

      {:ok, assignments} = InsightService.get_assignments_by_team(team)

      assert length(assignments) == 3
    end
  end
end
