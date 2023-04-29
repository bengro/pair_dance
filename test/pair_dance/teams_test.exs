defmodule PairDance.TeamsTest do
  use PairDance.DataCase

  alias PairDance.Teams
  alias PairDance.Teams.TaskOwnership

  import PairDance.TeamsFixtures

  describe "members" do
    alias PairDance.Teams.Member

    import PairDance.TeamsFixtures

    @invalid_attrs %{name: nil}

    defp create_team_and_member(attrs \\ %{}) do
      team = team_fixture()
      member = member_fixture(Enum.into(%{:team_id => team.id}, attrs))
      { team, member }
    end

    test "list_members/0 returns all members" do
      { _, member } = create_team_and_member()
      assert Teams.list_all_members() == [member]
    end

    test "list_members/1 returns all members of the team" do
      { team, member } = create_team_and_member()
      assert Teams.list_members(team.id) == [member]
    end

    test "get_member!/1 returns the member with given id" do
      { _, member } = create_team_and_member()
      assert Teams.get_member!(member.id) == member
    end

    test "create_member/1 with valid data creates a member" do
      team = team_fixture()
      assert {:ok, %Member{} = member} = Teams.create_member(%{name: "David B", team_id: team.id})
      assert member.name == "David B"
    end

    test "create_member/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_member(@invalid_attrs)
    end

    test "update_member/2 with valid data updates the member" do
      { _, member } = create_team_and_member()
      update_attrs = %{name: "Tod L"}

      assert {:ok, %Member{} = member} = Teams.update_member(member, update_attrs)
      assert member.name == "Tod L"
    end

    test "update_member/2 with invalid data returns error changeset" do
      { _, member } = create_team_and_member()
      assert {:error, %Ecto.Changeset{}} = Teams.update_member(member, @invalid_attrs)
      assert member == Teams.get_member!(member.id)
    end

    test "delete_member/1 deletes the member" do
      { _, member } = create_team_and_member()
      assert {:ok, %Member{}} = Teams.delete_member(member)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_member!(member.id) end
    end

    test "change_member/1 returns a member changeset" do
      { _, member } = create_team_and_member()
      assert %Ecto.Changeset{} = Teams.change_member(member)
    end
  end

  describe "tasks" do
    alias PairDance.Teams.Task

    import PairDance.TeamsFixtures

    @invalid_attrs %{name: nil}

    defp create_team_and_task(attrs \\ %{}) do
      team = team_fixture()
      task = task_fixture(Enum.into(%{:team_id => team.id}, attrs))
      { team, task }
    end

    test "list_all_tasks/0 returns all tasks" do
      {_,task} = create_team_and_task()
      assert Teams.list_all_tasks() == [task]
    end

    test "list_tasks/1 returns all tasks of the team" do
      {team,task} = create_team_and_task()
      assert Teams.list_tasks(team.id) == [task]
    end

    test "get_task!/1 returns the task with given id" do
      {_,task} = create_team_and_task()
      assert Teams.get_task!(task.id) == task
    end

    test "create_task/1 with valid data creates a task" do
      team = team_fixture()
      valid_attrs = %{name: "some name", team_id: team.id}

      assert {:ok, %Task{} = task} = Teams.create_task(valid_attrs)
      assert task.name == "some name"
    end

    test "create_task/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_task(@invalid_attrs)
    end

    test "update_task/2 with valid data updates the task" do
      {_,task} = create_team_and_task()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Task{} = task} = Teams.update_task(task, update_attrs)
      assert task.name == "some updated name"
    end

    test "update_task/2 with invalid data returns error changeset" do
      {_,task} = create_team_and_task()
      assert {:error, %Ecto.Changeset{}} = Teams.update_task(task, @invalid_attrs)
      assert task == Teams.get_task!(task.id)
    end

    test "delete_task/1 deletes the task" do
      {_,task} = create_team_and_task()
      assert {:ok, %Task{}} = Teams.delete_task(task)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_task!(task.id) end
    end

    test "change_task/1 returns a task changeset" do
      {_,task} = create_team_and_task()
      assert %Ecto.Changeset{} = Teams.change_task(task)
    end
  end

  describe "task ownership" do

    defp team_member_task(attrs \\ %{}) do
      team = team_fixture()
      member = member_fixture(Enum.into(%{:team_id => team.id}, %{}))
      task = task_fixture(Enum.into(%{:team_id => team.id}, attrs))
      { team, member, task }
    end

    test "create and retrieve" do
      { team, member, task } = team_member_task()

      Teams.create_ownership(task, member)
      [%TaskOwnership{} = ownership] = Teams.list_ownerships(team.id)

      assert ownership.task_id == task.id
      assert ownership.member_id == member.id
    end

    test "remove task ownership" do
      { team1, member1, task1 } = team_member_task()
      { team2, member2, task2 } = team_member_task()

      Teams.create_ownership(task1, member1)
      Teams.create_ownership(task2, member2)
      Teams.remove_ownership(task1, member1)

      assert [] = Teams.list_ownerships(team1.id)
      assert [_] = Teams.list_ownerships(team2.id)
    end

    test "only retrieves ownerships of the specified team" do
      { team1, member1, task1 } = team_member_task()
      { _, member2, task2 } = team_member_task()

      Teams.create_ownership(task1, member1)
      Teams.create_ownership(task2, member2)

      assert [ownership] = Teams.list_ownerships(team1.id)
      assert ownership.member_id == member1.id
    end

  end
end
