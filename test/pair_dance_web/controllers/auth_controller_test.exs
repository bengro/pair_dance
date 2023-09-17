defmodule PairDanceWeb.AuthControllerTest do
  use PairDanceWeb.ConnCase

  import PairDance.TeamsFixtures

  describe "jira_callback" do
    test "redirects to settings page", %{conn: conn} do
      team = create_team(%{member_names: [], task_names: []})

      conn = get(conn, ~p"/auth/jira?code=abc&state=#{team.descriptor.id}")

      assert redirected_to(conn) == ~p"/#{team.descriptor.slug}/settings"
    end
  end
end
