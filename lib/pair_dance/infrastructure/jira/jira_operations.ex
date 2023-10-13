defmodule PairDance.Infrastructure.Jira.Operations do
  @type integration_id :: String.t()
  @type integration :: PairDance.Domain.Integration.t()
  @type board_id :: integer
  @type upcoming_tickets_jql :: String.t()
  @type auth_code :: String.t()
  @type team_id :: String.t()

  @callback connect(team_id, auth_code) :: {:ok, integration_id}

  @callback configure(integration_id, board_id, upcoming_tickets_jql) :: :ok

  @callback list_upcoming_tickets(integration) :: {:ok, [JiraTicket.t()]}
end
