defmodule PairDance.Infrastructure.Jira.JiraServiceTest do
  use PairDance.DataCase
  alias PairDance.Infrastructure.Jira.JiraService

  test "connect an integration" do
    auth_code = "ey.ey.0"
    board_id = 553
    backlog_query = "project=10727%20AND%20status=%22In+Progress%22&fields=summary"

    {:ok, integration_id} = JiraService.connect(auth_code)

    :ok = JiraService.configure(integration_id, board_id, backlog_query)

    tickets = JiraService.list_upcoming_tickets(integration_id)

    assert length(tickets) > 0
  end
end
