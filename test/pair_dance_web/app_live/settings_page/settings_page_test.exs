defmodule PairDanceWeb.AppLive.SettingsPageTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.Integrations.EctoRepository, as: IntegrationRepository
  alias PairDance.Domain.Team.TeamService

  defp setup_data(_) do
    user = user_fixture()
    {:ok, team} = TeamService.new_team("my team", user)

    team = TeamRepository.find(team.descriptor.id)

    %{team: team, user: user}
  end

  setup [:setup_data]

  describe "member management" do
    test "invite a new member", %{conn: conn, team: team, user: user} do
      {:ok, view, _} =
        conn
        |> impersonate(user)
        |> live(~p"/#{team.descriptor.slug}/settings")

      view
      |> form("#add-member-form", new_member_form: %{email: "new-member@gmail.com"})
      |> render_submit()

      assert render(view) =~ "new-member@gmail.com"
    end

    test "invites must be a legit email", %{conn: conn, team: team, user: user} do
      {:ok, view, _} =
        conn
        |> impersonate(user)
        |> live(~p"/#{team.descriptor.slug}/settings")

      view
      |> form("#add-member-form", new_member_form: %{email: "some name"})
      |> render_submit()

      assert render(view) =~ "invalid format"
    end

    test "delete team member", %{conn: conn, team: team, user: user} do
      to_be_deleted_member = member_fixture(team, "someone@world.com")
      member_fixture(team, "someone-else@world.com")

      {:ok, view, _} =
        conn
        |> impersonate(user)
        |> live(~p"/#{team.descriptor.slug}/settings")

      view
      |> element("[data-qa=member-#{to_be_deleted_member.id}]")
      |> render_click()

      refute render(view) =~ "someone@world.com"
    end

    test "shows that current user has never logged in", %{conn: conn, team: team, user: user} do
      {:ok, _, html} =
        conn
        |> impersonate(user)
        |> live(~p"/#{team.descriptor.slug}/settings")

      {:ok, document} = Floki.parse_document(html)

      assert length(document |> Floki.find("[data-qa=user-has-never-logged-in]")) == 1
    end
  end

  describe "team management" do
    test "change team name and slug", %{conn: conn, team: team, user: user} do
      {:ok, view, _} =
        conn
        |> impersonate(user)
        |> live(~p"/#{team.descriptor.slug}/settings")

      {_,
       {_,
        %{
          to: redirect_path
        }}} =
        view
        |> form("#edit-team-form", team_form: %{name: "changed-team"})
        |> render_submit()

      assert redirect_path == "/changed-team/settings"
    end

    test "cannot change team name to invalid name", %{conn: conn, team: team, user: user} do
      {:ok, view, _} =
        conn
        |> impersonate(user)
        |> live(~p"/#{team.descriptor.slug}/settings")

      view
      |> form("#edit-team-form", team_form: %{name: "1"})
      |> render_submit()

      assert render(view) =~ "should be at least"
    end

    test "delete team", %{conn: conn, team: team, user: user} do
      {:ok, view, _} =
        conn
        |> impersonate(user)
        |> live(~p"/#{team.descriptor.slug}/settings")

      {:error, {:live_redirect, redirect_opts}} =
        view
        |> element("#delete_team_modal-confirm")
        |> render_click()

      assert redirect_opts.to == "/"
    end
  end

  describe "jira integration" do
    test "invites users to add integration when not integrated", %{
      conn: conn,
      team: team,
      user: user
    } do
      {:ok, view, _} =
        conn
        |> impersonate(user)
        |> live(~p"/#{team.descriptor.slug}/settings")

      assert render(view) =~ "Connect to Jira"
    end
  end

  test "can be configured", %{conn: conn, team: team, user: user} do
    IntegrationRepository.create(team.descriptor.id, %{})

    {:ok, view, _} =
      conn
      |> impersonate(user)
      |> live(~p"/#{team.descriptor.slug}/settings")

    view
    |> form("#jira-integration-form",
      jira_integration_form: %{backlog_query: "backlog-jql", board_id: "board-1"}
    )
    |> render_submit()

    {:ok, view, _} =
      conn
      |> impersonate(user)
      |> live(~p"/#{team.descriptor.slug}/settings")

    assert render(view) =~ "board-1"
    assert render(view) =~ "backlog-jql"
  end

  test "can disconnect an integration", %{conn: conn, team: team, user: user} do
    IntegrationRepository.create(team.descriptor.id, %{})

    {:ok, view, _} =
      conn
      |> impersonate(user)
      |> live(~p"/#{team.descriptor.slug}/settings")

    view
    |> element("[data-qa=disconnect-jira-integration]")
    |> render_click()

    {:ok, view, _} =
      conn
      |> impersonate(user)
      |> live(~p"/#{team.descriptor.slug}/settings")

    assert render(view) =~ "Connect to Jira"
  end
end
