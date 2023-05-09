defmodule PairDanceWeb.TeamPageTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  alias PairDance.Domain.TeamCreationService

  defp setup_data(_) do
    user = user_fixture()
    {:ok, team} = TeamCreationService.new_team("my team", user)
    task = task_fixture(team, "Refactor something amazing")

    %{tasks: [task], team: team, user: user}
  end

  setup [:setup_data]

  test "non-existing team", %{conn: conn, user: user} do
    assert {:error, {:redirect, %{to: "/"}}} = conn |> impersonate(user) |> live(~p"/non-existing-team")
  end

  test "requires authentication", %{conn: conn, team: team} do
    assert {:error, {:redirect, %{to: "/auth"}}} = live(conn, ~p"/#{team.slug}")
  end

  test "non-members get redirected away", %{conn: conn, team: team} do
    another_user = user_fixture("another@user.com")
    assert {:error, {:redirect, %{to: "/"}}} = conn |> impersonate(another_user) |> live(~p"/#{team.slug}")
  end

  test "lists all members", %{conn: conn, team: team, user: user} do
    {:ok, _index_live, html} = conn |> impersonate(user) |> live(~p"/#{team.slug}")

    assert html =~ "Team members:"
    assert html =~ user.email
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
