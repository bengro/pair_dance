defmodule PairDanceWeb.AppLive.InsightsPageTest do
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

  test "shows people pairing most", %{conn: conn, user: user, team: team} do
    {:ok, _, html} =
      conn
      |> impersonate(user)
      |> live(~p"/#{team.descriptor.slug}/insights")

    assert html =~ "Who paired the most"
  end

  test "shows people pairing with other people", %{conn: conn, user: user, team: team} do
    {:ok, _, html} =
      conn
      |> impersonate(user)
      |> live(~p"/#{team.descriptor.slug}/insights")

    assert html =~ "Who paired with who"
  end

  test "shows personal pairing calendar", %{conn: conn, user: user, team: team} do
    {:ok, _, html} =
      conn
      |> impersonate(user)
      |> live(~p"/#{team.descriptor.slug}/insights")

    assert html =~ "When have you paired"
  end

  test "shows team's recent task assignments", %{conn: conn, user: user, team: team} do
    {:ok, _, html} =
      conn
      |> impersonate(user)
      |> live(~p"/#{team.descriptor.slug}/insights")

    assert html =~ "Who has context on what"
    assert html =~ Enum.at(team.tasks, 0).name
  end
end
