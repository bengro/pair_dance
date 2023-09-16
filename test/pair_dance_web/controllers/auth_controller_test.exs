defmodule PairDanceWeb.AuthControllerTest do
  use PairDanceWeb.ConnCase

  describe "jira_callback" do
    test "redirects to settings page", %{conn: conn} do
      conn = get(conn, ~p"/auth/jira?code=abc&state=team-x")

      assert redirected_to(conn) == ~p"/team-x/settings"
    end
  end
end
