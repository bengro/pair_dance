defmodule PairDanceWeb.AppLive.AccountPageTest do
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
end
