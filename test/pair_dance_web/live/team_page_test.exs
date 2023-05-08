defmodule PairDanceWeb.TeamPageTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  defp setup_data(_) do
    user = user_fixture()
    team = team_fixture()
    member = member_fixture(team)
    task = task_fixture(team, "Refactor something amazing")

    %{members: [member], tasks: [task], team: team, user: user}
  end

  setup [:setup_data]

  test "non-existing team", %{conn: conn, user: user} do
    {:ok, _index_live, html} = conn |> impersonate(user) |> live(~p"/non-existing-team")

    assert html =~ "not found"
  end

  test "requires authentication", %{conn: conn, team: team} do
    assert {:error, {:redirect, %{flash: %{}, to: "/auth"}}} = live(conn, ~p"/#{team.slug}")
  end

  test "lists all members", %{conn: conn, members: members, team: team, user: user} do
    {:ok, _index_live, html} = conn |> impersonate(user) |> live(~p"/#{team.slug}")

    [first_member] = members

    assert html =~ "Team members:"
    assert html =~ first_member.user.email
  end

  test "lists all tasks", %{conn: conn, tasks: tasks, team: team, user: user} do
    {:ok, _index_live, html} = conn |> impersonate(user) |> live(~p"/#{team.slug}")

    [first_task] = tasks

    assert html =~ "Tasks:"
    assert html =~ first_task.name
  end

  test "create a task", %{conn: conn, team: team, user: user} do
    {:ok, view, _} = conn |> impersonate(user) |> live(~p"/#{team.slug}")

    view
    |> form("#new-task-form", task: %{name: "my task name"})
    |> render_submit()

    assert render(view) =~ "my task name"
  end
end
