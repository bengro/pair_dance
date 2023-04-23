defmodule PairDance.TeamsTest do
  use PairDance.DataCase

  alias PairDance.Teams

  describe "teams" do
    alias PairDance.Teams.Team

    import PairDance.TeamsFixtures

    @invalid_attrs %{name: nil}

    test "list_teams/0 returns all teams" do
      team = team_fixture()
      assert Teams.list_teams() == [team]
    end

    test "get_team!/1 returns the team with given id" do
      team = team_fixture()
      assert Teams.get_team!(team.id) == team
    end

    test "get_team/1 returns the team with given id" do
      team = team_fixture()
      assert Teams.get_team(team.id) == team
    end

    test "get_team/1 returns an error when team not found" do
      assert Teams.get_team(99999) == nil
    end

    test "create_team/1 with valid data creates a team" do
      valid_attrs = %{name: "some name"}

      assert {:ok, %Team{} = team} = Teams.create_team(valid_attrs)
      assert team.name == "some name"
    end

    test "create_team/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Teams.create_team(@invalid_attrs)
    end

    test "update_team/2 with valid data updates the team" do
      team = team_fixture()
      update_attrs = %{name: "some updated name"}

      assert {:ok, %Team{} = team} = Teams.update_team(team, update_attrs)
      assert team.name == "some updated name"
    end

    test "update_team/2 with invalid data returns error changeset" do
      team = team_fixture()
      assert {:error, %Ecto.Changeset{}} = Teams.update_team(team, @invalid_attrs)
      assert team == Teams.get_team!(team.id)
    end

    test "delete_team/1 deletes the team" do
      team = team_fixture()
      assert {:ok, %Team{}} = Teams.delete_team(team)
      assert_raise Ecto.NoResultsError, fn -> Teams.get_team!(team.id) end
    end

    test "change_team/1 returns a team changeset" do
      team = team_fixture()
      assert %Ecto.Changeset{} = Teams.change_team(team)
    end
  end

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
end
