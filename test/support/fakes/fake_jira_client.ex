defmodule PairDance.Infrastructure.Jira.FakeJiraClient do
  @behaviour PairDance.Infrastructure.Jira.Operations

  def connect(auth_code) do
    {:ok, "integration-1"}
  end

  def configure(integration_id, board_id, backlog_query) do
    :ok
  end

  def list_upcoming_tickets(_integration_id) do
    [%{}]
  end
end
