defmodule PairDance.Infrastructure.Jira.JiraService do
  alias PairDance.Infrastructure.Jira.Operations

  def list_upcoming_tickets(token, host, board_id, jql_query) do
    jira_client().list_upcoming_tickets(token, host, board_id, jql_query)
  end

  @spec jira_client() :: Operations.t()
  defp jira_client do
    Application.get_env(:pair_dance, :jira_client)
  end
end
