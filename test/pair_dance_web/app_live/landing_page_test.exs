defmodule PairDanceWeb.AppLive.LandingPageTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  setup %{conn: conn} do
    user = user_fixture("bob@pair.dance")
    %{user: user, conn: conn}
  end

  test "shows feature list when not logged in", %{conn: conn} do
    {:ok, _, html} = conn |> live(~p"/")

    assert html =~ "Check out the amazing pair.dance features"
  end

  test "shows dashboard when logged in", %{conn: conn, user: user} do
    {:ok, _, html} =
      conn
      |> impersonate(user)
      |> live(~p"/")

    assert html =~ "Hi"
  end
end
