defmodule PairDance.Infrastructure.Jira.FakeJiraClient do
  @behaviour PairDance.Infrastructure.Jira.Operations

  def connect(_team_id, _auth_code) do
    {:ok, "integration-1"}
  end

  def configure(_integration_id, _board_id, _backlog_query) do
    :ok
  end

  def list_upcoming_tickets(_integration) do
    [%{}]
  end
end
