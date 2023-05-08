defmodule PairDanceWeb.TeamMembersPageTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  defp setup_data(_) do
    team = team_fixture()
    user = user_fixture()

    %{team: team, user: user}
  end

  describe "Index" do
    setup [:setup_data]

    test "view team members", %{conn: conn, team: team, user: user} do
      {:ok, _index_live, html} = conn
        |> impersonate(user)
        |> live(~p"/#{team.slug}/members")

      assert html =~ "Team members:"
    end

    test "invite a new member", %{conn: conn, team: team, user: user} do
      {:ok, view, _} = conn
        |> impersonate(user)
        |> live(~p"/#{team.slug}/members")

      view
        |> form("#add-member-form", user: %{ email: "bob@gmail.com" })
        |> render_submit()

      assert render(view) =~ "bob@gmail.com"
    end
  end
end
