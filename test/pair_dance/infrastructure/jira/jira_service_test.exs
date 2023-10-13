defmodule PairDance.Infrastructure.Jira.JiraClientTest do
  use PairDance.DataCase
  alias PairDance.Infrastructure.Jira.JiraClient
  alias PairDance.Infrastructure.Integrations.EctoRepository

  @tag :skip
  test "connect an integration" do
    board_id = System.fetch_env!("CONTRACT_TEST_JIRA_BOARD_ID")
    upcoming_tickets_jql = System.fetch_env!("CONTRACT_TEST_JIRA_upcoming_tickets_jql")

    {:ok, integration} =
      EctoRepository.create(1, %{
        refresh_token: System.fetch_env!("CONTRACT_TEST_JIRA_REFRESH_TOKEN"),
        board_id: board_id,
        upcoming_tickets_jql: upcoming_tickets_jql
      })

    tickets = JiraClient.list_upcoming_tickets(integration)

    assert length(tickets) > 0
  end
end
