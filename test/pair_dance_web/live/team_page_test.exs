defmodule PairDanceWeb.TeamPageTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  defp setup_data(_) do
    team = team_fixture()
    member = member_fixture(team)
    task = task_fixture(%{:team_id => team.id, :name => "Refactor something amazing"})

    %{members: [member], tasks: [task], team: team}
  end

  setup [:setup_data]

  test "non-existing team", %{conn: conn} do
    {:ok, _index_live, html} = live(conn, ~p"/non-existing-team")

    assert html =~ "not found"
  end

  test "lists all members", %{conn: conn, members: members, team: team} do
    {:ok, _index_live, html} = live(conn, ~p"/#{team.slug}")

    [first_member] = members

    assert html =~ "Team members:"
    assert html =~ first_member.user.email
  end

  test "lists all tasks", %{conn: conn, tasks: tasks, team: team} do
    {:ok, _index_live, html} = live(conn, ~p"/#{team.slug}")

    [first_task] = tasks

    assert html =~ "Tasks:"
    assert html =~ first_task.name
  end

  test "create a task", %{conn: conn, team: team} do
    {:ok, index_live, _} = live(conn, ~p"/#{team.slug}")

    index_live
    |> form("#new-task-form", task: %{name: "my task name"})
    |> render_submit()

    {:ok, _, html_after_refresh} = live(conn, ~p"/#{team.slug}")

    assert html_after_refresh =~ "my task name"
  end
end
