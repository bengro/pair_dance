defmodule PairDanceWeb.AccountPageTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  defp setup_data(_) do
    user = user_fixture("bob@pair.dance")
    %{user: user}
  end

  setup [:setup_data]

  test "shows current user", %{conn: conn, user: user} do
    {:ok, _, html} = conn |> impersonate(user) |> live(~p"/!/account")

    assert html =~ "bob@pair.dance"
  end

  test "create a team", %{conn: conn, user: user} do
    {:ok, view, _} = conn |> impersonate(user) |> live(~p"/!/account")

    view
    |> form("#new-team-form", team: %{name: "comet"})
    |> render_submit()

    assert_redirected(view, "/comet")
  end
end
