defmodule PairDanceWeb.LandingPageTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest

  test "create a team", %{conn: conn} do
    {:ok, view, _} = conn |> impersonate(%{}) |> live(~p"/")

    view
    |> form("#new-team-form", team: %{name: "comet"})
    |> render_submit()

    assert_redirected(view, "/comet")
  end
end
