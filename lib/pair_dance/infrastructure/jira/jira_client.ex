defmodule PairDance.Infrastructure.Jira.JiraClient do
  @behaviour PairDance.Infrastructure.Jira.Operations

  def list_upcoming_tickets(token, host, board_id, jql_query) do
    url = "#{host}/rest/agile/1.0/board/#{board_id}/issue?jql=#{jql_query}"

    {:ok, response} =
      Finch.build(
        :get,
        url,
        [
          {"Authorization", "Basic #{Base.encode64(token)}"},
          {"Accept", "application/json"}
        ]
      )
      |> Finch.request(PairDance.Finch)

    Jason.decode!(response.body)["issues"]
  end
end
