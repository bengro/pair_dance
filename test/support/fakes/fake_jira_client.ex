defmodule PairDance.Infrastructure.Jira.FakeJiraClient do
  @behaviour PairDance.Infrastructure.Jira.Operations

  def list_upcoming_tickets(_token, _host, _board_id, _jql_query) do
    [%{}]
  end
end
