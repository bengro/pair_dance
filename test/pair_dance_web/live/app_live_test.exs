defmodule PairDanceWeb.AppLiveTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  defp setup_data(_) do
    team = team_fixture()
    member = member_fixture(%{:team_id => team.id, :name => "Alice"})
    task = task_fixture(%{:team_id => team.id, :name => "Refactor something amazing"})

    %{members: [member], tasks: [task], team: team}
  end

  describe "Index" do
    setup [:setup_data]

    test "lists all members", %{conn: conn, members: members} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      [first_member] = members

      assert html =~ "Team members:"
      assert html =~ first_member.name
    end

    test "lists all tasks", %{conn: conn, tasks: tasks} do
      {:ok, _index_live, html} = live(conn, ~p"/")

      [first_task] = tasks

      assert html =~ "Tasks:"
      assert html =~ first_task.name
    end

    test "create a task", %{conn: conn, team: team} do
      {:ok, index_live, _} = live(conn, ~p"/")

      {:ok, _, html} =
        index_live
        |> form("#new-task-form", task: %{ name: "my task name" })
        |> render_submit()


      assert html =~ "my task name"
    end
  end
end
