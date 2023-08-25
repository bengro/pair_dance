defmodule PairDance.Infrastructure.Jira.Operations do
  @type token :: String.t()
  @type host :: String.t()
  @type board_id :: integer
  @type jql_query :: String.t()

  @callback list_upcoming_tickets(token, host, board_id, jql_query) :: {:ok, [JiraTicket.t()]}
end
