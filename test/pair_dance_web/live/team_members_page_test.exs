defmodule PairDanceWeb.TeamMembersPageTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  defp setup_data(_) do
    team = team_fixture()

    %{team: team}
  end

  describe "Index" do
    setup [:setup_data]

    test "view team members", %{conn: conn, team: team} do
      {:ok, _index_live, html} = live(conn, ~p"/teams/#{team.id}/members")

      assert html =~ "Team members:"
    end

    test "invite a new member", %{conn: conn, team: team} do
      {:ok, view, _} = live(conn, ~p"/teams/#{team.id}/members")

      view
        |> form("#add-member-form", user: %{ email: "bob@gmail.com" })
        |> render_submit()

      assert render(view) =~ "bob@gmail.com"
    end
  end
end
