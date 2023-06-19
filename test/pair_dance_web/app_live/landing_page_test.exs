defmodule PairDanceWeb.AppLive.LandingPageTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  setup %{conn: conn} do
    team =
      create_team(%{
        member_names: ["bob"],
        task_names: ["refactor fedramp", "closed beta"]
      })
      |> create_assignment("refactor fedramp", "bob")

    user = Enum.at(team.members, 0).user

    %{user: user, conn: conn, team: team}
  end

  test "shows feature list when not logged in", %{conn: conn} do
    {:ok, _, html} = conn |> live(~p"/")

    assert html =~ "Check out the amazing pair.dance features"
  end

  describe "when logged in" do
    test "shows teams I belong to when logged in", %{conn: conn, user: user, team: team} do
      {:ok, _, html} =
        conn
        |> impersonate(user)
        |> live(~p"/")

      assert html =~ team.name
    end

    test "shows recent tasks", %{conn: conn, user: user, team: team} do
      {:ok, _, html} =
        conn
        |> impersonate(user)
        |> live(~p"/")

      assert html =~ "Activity"
      assert html =~ Enum.at(team.tasks, 0).name
    end
  end
end
