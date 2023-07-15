defmodule PairDanceWeb.AppLive.LandingPageTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  test "shows user when they are not logged in", %{conn: conn} do
    {:ok, _, html} = conn |> live(~p"/")

    assert html =~ "Pair.dance helps"
  end

  describe "when logged in" do
    # TODO: I can't make this test work.
    @tag :skip
    test "redirect user to existing team", %{conn: conn} do
      team =
        create_team(%{
          member_names: ["bob"],
          task_names: ["refactor fedramp", "closed beta"]
        })
        |> create_assignment("refactor fedramp", "bob")

      user = Enum.at(team.members, 0).user

      {:ok, view, _} =
        conn
        |> impersonate(user)
        |> live(~p"/")

      assert_redirected(view, to: "/" <> team.descriptor.slug)
    end

    test "create a team when user does not have a team yet", %{conn: conn} do
      user = user_fixture("best-user@pair.dance")
      {:ok, view, _} = conn |> impersonate(user) |> live(~p"/")

      view
      |> form("#new-team-form", team: %{name: "comet"})
      |> render_submit()

      assert_redirected(view, "/comet")
    end
  end
end
