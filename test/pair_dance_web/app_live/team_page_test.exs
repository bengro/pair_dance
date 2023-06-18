defmodule PairDanceWeb.AppLive.TeamPageTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  alias PairDance.Domain.Team.TeamService

  defp setup_data(_) do
    user = user_fixture()
    {:ok, team} = TeamService.new_team("my team", user)
    task_fixture(team, "Refactor something amazing")
    task_fixture(team, "Implement FedRamp-compliant cache")

    team = PairDance.Infrastructure.Team.EctoRepository.find(team.id)

    %{team: team, user: user}
  end

  setup [:setup_data]

  test "non-existing team", %{conn: conn, user: user} do
    assert {:error, {:redirect, %{to: "/"}}} =
             conn |> impersonate(user) |> live(~p"/non-existing-team")
  end

  test "requires authentication", %{conn: conn, team: team} do
    assert {:error, {:redirect, %{to: "/auth"}}} = live(conn, ~p"/#{team.slug}")
  end

  test "non-members get redirected away", %{conn: conn, team: team} do
    another_user = user_fixture("another@user.com")

    assert {:error, {:redirect, %{to: "/"}}} =
             conn |> impersonate(another_user) |> live(~p"/#{team.slug}")
  end

  test "lists team members", %{conn: conn, team: team, user: user} do
    {:ok, _index_live, html} = conn |> impersonate(user) |> live(~p"/#{team.slug}")
    assert html =~ user.email
  end

  test "invite a new member", %{conn: conn, team: team, user: user} do
    {:ok, view, _} =
      conn
      |> impersonate(user)
      |> live(~p"/#{team.slug}")

    view
    |> form("#add-member-form", user: %{email: "new-member@gmail.com"})
    |> render_submit()

    assert render(view) =~ "new-member@gmail.com"
  end

  test "lists all tasks", %{conn: conn, team: team, user: user} do
    {:ok, _view, html} = conn |> impersonate(user) |> live(~p"/#{team.slug}")

    [first_task | _] = team.tasks

    assert html =~ first_task.name
  end

  test "create a task", %{conn: conn, team: team, user: user} do
    {:ok, view, _} = conn |> impersonate(user) |> live(~p"/#{team.slug}")

    view
    |> form("#new-task-form", task: %{name: "my task name"})
    |> render_submit()

    assert render(view) =~ "my task name"
  end

  test "delete a task", %{conn: conn, team: team, user: user} do
    {:ok, view, _} = conn |> impersonate(user) |> live(~p"/#{team.slug}")
    [task | _] = team.tasks

    assert render(view) =~ task.name

    updated_view =
      view
      |> element("[data-qa=delete-task-#{task.id}]")
      |> render_click()

    refute String.contains?(updated_view, task.name)
  end

  test "assign member to a task", %{conn: conn, team: team, user: user} do
    {:ok, view, _} = conn |> impersonate(user) |> live(~p"/#{team.slug}")

    [task | _] = team.tasks

    payload = %{
      "userId" => user.id,
      "newTaskId" => "#{task.id}"
    }

    view
    |> element("#available-members")
    |> render_hook(:reassign, payload)

    {:ok, _view, updated_html} = conn |> impersonate(user) |> live(~p"/#{team.slug}")

    {:ok, document} = Floki.parse_document(updated_html)

    assert document
           |> Floki.find("[data-qa=workstream]")
           |> Enum.filter(fn el -> Floki.text(el) =~ task.name end)
           |> Floki.text() =~ user.email
  end

  test "unassign member from a task", %{conn: conn, team: team, user: user} do
    {:ok, view, _} = conn |> impersonate(user) |> live(~p"/#{team.slug}")

    [task | _] = team.tasks

    view
    |> element("#available-members")
    |> render_hook(
      :reassign,
      %{
        "userId" => user.id,
        "newTaskId" => "#{task.id}"
      }
    )

    view
    |> element("#available-members")
    |> render_hook(
      :reassign,
      %{
        "userId" => user.id,
        "oldTaskId" => "#{task.id}"
      }
    )

    {:ok, _view, updated_html} = conn |> impersonate(user) |> live(~p"/#{team.slug}")

    {:ok, document} = Floki.parse_document(updated_html)

    assert document
           |> Floki.find("[data-qa=available-members]")
           |> Floki.text() =~ user.email
  end

  test "reassign member to another task", %{conn: conn, team: team, user: user} do
    {:ok, view, _} = conn |> impersonate(user) |> live(~p"/#{team.slug}")

    [first_task, second_task] = team.tasks

    view
    |> element("#available-members")
    |> render_hook(
      :reassign,
      %{
        "userId" => user.id,
        "newTaskId" => "#{first_task.id}"
      }
    )

    view
    |> element("#available-members")
    |> render_hook(
      :reassign,
      %{
        "userId" => user.id,
        "oldTaskId" => "#{first_task.id}",
        "newTaskId" => "#{second_task.id}"
      }
    )

    {:ok, _view, updated_html} = conn |> impersonate(user) |> live(~p"/#{team.slug}")

    {:ok, document} = Floki.parse_document(updated_html)

    assert document
           |> Floki.find("[data-qa=workstream]")
           |> Enum.filter(fn el -> Floki.text(el) =~ second_task.name end)
           |> Floki.text() =~ user.email
  end
end
