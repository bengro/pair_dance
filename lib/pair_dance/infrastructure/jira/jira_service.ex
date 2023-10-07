defmodule PairDance.Infrastructure.Jira.JiraService do
  alias PairDance.Infrastructure.Jira.Operations

  def connect(team_id, auth_code) do
    jira_client().connect(team_id, auth_code)
  end

  def configure(integration_id, board_id, backlog_query) do
    jira_client().configure(integration_id, board_id, backlog_query)
  end

  def list_upcoming_tickets(integration) do
    jira_client().list_upcoming_tickets(integration)
  end

  @spec jira_client() :: Operations.t()
  defp jira_client do
    Application.get_env(:pair_dance, :jira_client)
  end
end
