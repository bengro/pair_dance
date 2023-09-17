defmodule PairDance.Infrastructure.Jira.JiraClientTest do
  use PairDance.DataCase
  alias PairDance.Infrastructure.Jira.JiraClient
  alias PairDance.Infrastructure.Integrations.EctoRepository

  test "connect an integration" do
    board_id = System.fetch_env!("CONTRACT_TEST_JIRA_BOARD_ID")
    backlog_query = System.fetch_env!("CONTRACT_TEST_JIRA_BACKLOG_QUERY")

    {:ok, integration} =
      EctoRepository.create(%{
        refresh_token: System.fetch_env!("CONTRACT_TEST_JIRA_REFRESH_TOKEN"),
        board_id: board_id,
        backlog_query: backlog_query
      })

    tickets = JiraClient.list_upcoming_tickets(integration.id)

    assert length(tickets) > 0
  end
end
