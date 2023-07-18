defmodule PairDanceWeb.AppLive.SettingsPageTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Domain.Team.TeamService

  defp setup_data(_) do
    user = user_fixture()
    {:ok, team} = TeamService.new_team("my team", user)

    team = TeamRepository.find(team.descriptor.id)

    %{team: team, user: user}
  end

  setup [:setup_data]

  test "invite a new member", %{conn: conn, team: team, user: user} do
    {:ok, view, _} =
      conn
      |> impersonate(user)
      |> live(~p"/#{team.descriptor.slug}/settings")

    view
    |> form("#add-member-form", user: %{email: "new-member@gmail.com"})
    |> render_submit()

    assert render(view) =~ "new-member@gmail.com"
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
