defmodule PairDance.Infrastructure.Jira.JiraServiceTest do
  use PairDance.DataCase
  alias PairDance.Infrastructure.Jira.JiraService

  test "list upcoming tickets from board" do
    token = "something"
    host = "https://mycompany.atlassian.net"
    board_id = 553
    jql_query = "project=10727%20AND%20status=%22In+Progress%22&fields=summary"

    tickets =
      JiraService.list_upcoming_tickets(
        token,
        host,
        board_id,
        jql_query
      )

    assert length(tickets) > 0
  end
end
