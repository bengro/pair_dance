defmodule PairDanceWeb.AppLive.LandingPageTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  describe "when not logged in" do
    test "shows the external landing page", %{conn: conn} do
      {:ok, _, html} = conn |> live(~p"/")

      assert html =~ "Pair.dance helps"
    end
  end

  describe "when logged in" do
    test "redirect user to existing team", %{conn: conn} do
      team =
        create_team(%{
          member_names: ["bob"],
          task_names: ["refactor fedramp", "closed beta"]
        })
        |> create_assignment("refactor fedramp", "bob")

      user = Enum.at(team.members, 0).user

      {:error, {:live_redirect, redirect_opts}} =
        conn
        |> impersonate(user)
        |> live(~p"/")

      assert redirect_opts.to == "/" <> team.descriptor.slug
    end

    test "prompts user to create a team when user does not have a team yet", %{conn: conn} do
      user = user_fixture("best-user@pair.dance")
      {:ok, view, _} = conn |> impersonate(user) |> live(~p"/")

      assert render(view) =~ "Create a team"
    end
  end
end
