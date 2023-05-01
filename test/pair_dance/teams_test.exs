defmodule PairDance.TeamsTest do
  use PairDance.DataCase

  alias PairDance.Teams

  import PairDance.TeamsFixtures

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
