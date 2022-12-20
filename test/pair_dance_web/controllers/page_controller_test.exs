defmodule PairDanceWeb.PageControllerTest do
  use PairDanceWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Pair Dance"
  end
end
