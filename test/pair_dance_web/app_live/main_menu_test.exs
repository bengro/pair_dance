defmodule PairDanceWeb.Common.MainMenuTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  test "create a new team via the modal", %{conn: conn} do
    user = user_fixture("best-user@pair.dance")
    {:ok, view, _} = conn |> impersonate(user) |> live(~p"/")

    view
    |> form("#new-team-form", team: %{name: "comet"})
    |> render_submit()

    assert_redirected(view, "/comet")
  end
end
