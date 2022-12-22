defmodule PairDanceWeb.TaskLiveTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_task(_) do
    team = team_fixture()
    task = task_fixture(%{team_id: team.id})
    %{task: task}
  end

  describe "Index" do
    setup [:create_task]

    test "lists all tasks", %{conn: conn, task: task} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/tasks")

      assert html =~ "Listing Tasks"
      assert html =~ task.name
    end

    test "saves new task", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/tasks")

      assert index_live |> element("a", "New Task") |> render_click() =~
               "New Task"

      assert_patch(index_live, ~p"/admin/tasks/new")

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      team = team_fixture()
      valid_task = %{name: "a new task", team_id: team.id}

      {:ok, _, html} =
        index_live
        |> form("#task-form", task: valid_task)
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/tasks")

      assert html =~ "Task created successfully"
      assert html =~ "some name"
    end

    test "updates task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/tasks")

      assert index_live |> element("#tasks-#{task.id} a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(index_live, ~p"/admin/tasks/#{task}/edit")

      assert index_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#task-form", task: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/tasks")

      assert html =~ "Task updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes task in listing", %{conn: conn, task: task} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/tasks")

      assert index_live |> element("#tasks-#{task.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#task-#{task.id}")
    end
  end

  describe "Show" do
    setup [:create_task]

    test "displays task", %{conn: conn, task: task} do
      {:ok, _show_live, html} = live(conn, ~p"/admin/tasks/#{task}")

      assert html =~ "Show Task"
      assert html =~ task.name
    end

    test "updates task within modal", %{conn: conn, task: task} do
      {:ok, show_live, _html} = live(conn, ~p"/admin/tasks/#{task}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Task"

      assert_patch(show_live, ~p"/admin/tasks/#{task}/show/edit")

      assert show_live
             |> form("#task-form", task: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#task-form", task: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/admin/tasks/#{task}")

      assert html =~ "Task updated successfully"
      assert html =~ "some updated name"
    end
  end
end
