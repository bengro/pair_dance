defmodule PairDance.Infrastructure.Jira.FakeJiraClient do
  @behaviour PairDance.Infrastructure.Jira.Operations

  def connect(_team_id, _auth_code) do
    {:ok, "integration-1"}
  end

  def configure(_integration_id, _board_id, _upcoming_tickets_jql) do
    :ok
  end

  def list_upcoming_tickets(_integration) do
    [%{title: "Become FedRamp compliant", id: "PD-1"}]
  end

  def list_upcoming_tickets(nil) do
    []
  end
end
