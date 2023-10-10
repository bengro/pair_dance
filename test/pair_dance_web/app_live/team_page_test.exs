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

    team = PairDance.Infrastructure.Team.EctoRepository.find(team.descriptor.id)

    %{team: team, user: user}
  end

  setup [:setup_data]

  test "non-existing team", %{conn: conn, user: user} do
    assert {:error, {:redirect, %{to: "/"}}} =
             conn |> impersonate(user) |> live(~p"/non-existing-team")
  end

  test "requires authentication", %{conn: conn, team: team} do
    assert {:error, {:redirect, %{to: "/"}}} = live(conn, ~p"/#{team.descriptor.slug}")
  end

  test "non-members get redirected away", %{conn: conn, team: team} do
    another_user = user_fixture("another@user.com")

    assert {:error, {:redirect, %{to: "/"}}} =
             conn |> impersonate(another_user) |> live(~p"/#{team.descriptor.slug}")
  end

  test "lists team members", %{conn: conn, team: team, user: user} do
    {:ok, _index_live, html} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")
    assert html =~ user.approximate_name
  end

  describe "tasks" do
    test "create a task", %{conn: conn, team: team, user: user} do
      {:ok, view, _} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")

      view
      |> form("#new-task-form", new_task_form: %{name: "my task name"})
      |> render_submit()

      assert render(view) =~ "my task name"
    end

    test "edit a task", %{conn: conn, team: team, user: user} do
      [task | _] = team.tasks

      {:ok, view, _} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")

      view
      |> element("[data-qa=action-to-edit-task-#{task.id}]")
      |> render_click()

      view
      |> form("#edit-task-form-#{task.id}", edit_task_form: %{name: "Much better named task"})
      |> render_submit()

      assert render(view) =~ "Much better named task"
    end

    test "cannot create an invalid task", %{conn: conn, team: team, user: user} do
      {:ok, view, _} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")

      view
      |> form("#new-task-form", new_task_form: %{name: "1"})
      |> render_submit()

      assert render(view) =~ "should be at least"
    end

    test "delete a task", %{conn: conn, team: team, user: user} do
      {:ok, view, _} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")
      [task | _] = team.tasks

      assert render(view) =~ task.name

      view
      |> element("[data-qa=delete-task-#{task.id}]")
      |> render_click()

      refute render(view) =~ task.name
    end

    test "lists all tasks", %{conn: conn, team: team, user: user} do
      {:ok, _view, html} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")

      [first_task | _] = team.tasks

      assert html =~ first_task.name
    end
  end

  describe "jira integration" do
    test "create a task from jira", %{conn: conn, team: team, user: user} do
      jira_integration_fixture(team)

      {:ok, view, _html} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")

      view
      |> element("[data-qa=jira-ticket-PD-1]")
      |> render_click()

      {:ok, _view, html} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")
      {:ok, document} = Floki.parse_document(html)

      assert document
             |> Floki.find("[data-qa=pairing-table]")
             |> Floki.text() =~ "Become FedRamp compliant"

      assert document
             |> Floki.find("[data-qa=pairing-table]")
             |> Floki.text() =~ "PD-1"
    end
  end

  describe "assignments" do
    test "assign member to a task", %{conn: conn, team: team, user: user} do
      {:ok, view, _} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")

      [task | _] = team.tasks

      payload = %{
        "userId" => user.id,
        "newTaskId" => "#{task.id}"
      }

      view
      |> element("#available-members")
      |> render_hook(:reassign, payload)

      {:ok, _view, updated_html} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")

      {:ok, document} = Floki.parse_document(updated_html)

      assert document
             |> Floki.find("[data-qa=workstream]")
             |> Enum.filter(fn el -> Floki.text(el) =~ task.name end)
             |> Floki.text() =~ user.approximate_name
    end

    test "unassign member from a task", %{conn: conn, team: team, user: user} do
      {:ok, view, _} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")

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

      {:ok, _view, updated_html} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")

      {:ok, document} = Floki.parse_document(updated_html)

      assert document
             |> Floki.find("[data-qa=available-members]")
             |> Floki.text() =~ user.approximate_name
    end

    test "reassign member to another task", %{conn: conn, team: team, user: user} do
      {:ok, view, _} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")

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

      {:ok, _view, updated_html} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")

      {:ok, document} = Floki.parse_document(updated_html)

      assert document
             |> Floki.find("[data-qa=workstream]")
             |> Enum.filter(fn el -> Floki.text(el) =~ second_task.name end)
             |> Floki.text() =~ user.approximate_name
    end
  end

  describe "member availability" do
    test "mark member unavailable without a prior task", %{conn: conn, team: team, user: user} do
      {:ok, view, _} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")

      view
      |> element("#unavailable-members")
      |> render_hook(
        :mark_member_unavailable,
        %{
          "userId" => user.id
        }
      )

      {:ok, _view, updated_html} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")

      {:ok, document} = Floki.parse_document(updated_html)

      assert document
             |> Floki.find("[data-qa=unavailable-members]")
             |> Floki.text() =~ user.approximate_name
    end

    test "mark member unavailable with a prior task", %{conn: conn, team: team, user: user} do
      {:ok, view, _} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")

      [first_task, _] = team.tasks

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
      |> element("#unavailable-members")
      |> render_hook(
        :mark_member_unavailable,
        %{
          "userId" => user.id,
          "oldTaskId" => "#{first_task.id}"
        }
      )

      {:ok, _view, updated_html} = conn |> impersonate(user) |> live(~p"/#{team.descriptor.slug}")

      {:ok, document} = Floki.parse_document(updated_html)

      assert document
             |> Floki.find("[data-qa=unavailable-members]")
             |> Floki.text() =~ user.approximate_name
    end
  end
end
