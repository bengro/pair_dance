defmodule PairDance.Infrastructure.Integrations.EctoRepositoryTest do
  use PairDance.DataCase

  alias PairDance.Infrastructure.Integrations.EctoRepository, as: Repository
  alias PairDance.Domain.Integration

  test "create an integration" do
    {:ok, integration} = Repository.create(%{refresh_token: "the token"})

    assert %Integration{id: id} = integration
    assert id
    assert integration.credentials.refresh_token == "the token"
  end

  test "configure the integration" do
    {:ok, %Integration{id: id}} = Repository.create(%{refresh_token: "the token"})

    {:ok, integration} =
      Repository.update_settings(id, %{board_id: 123, backlog_query: "jql query"})

    assert integration.settings.board_id == 123
    assert integration.settings.backlog_query == "jql query"
    assert integration.credentials.refresh_token == "the token"
  end
end
