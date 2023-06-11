defmodule PairDanceWeb.LandingPageTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest

  test "accessible without logging in", %{conn: conn} do
    {:ok, _, html} = conn |> live(~p"/")

    assert html =~ "pair.dance"
  end

end
