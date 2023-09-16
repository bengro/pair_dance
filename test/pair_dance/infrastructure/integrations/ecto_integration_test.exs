defmodule PairDance.Infrastructure.Integrations.EctoRepositoryTest do
  use PairDance.DataCase

  alias PairDance.Infrastructure.Integrations.EctoRepository, as: Repository
  alias PairDance.Domain.Integration

  test "create an integration" do
    {:ok, integration} = Repository.create(%{refresh_token: "the token"})

    assert %Integration{id: id} = integration
    assert id
    assert integration.settings.refresh_token == "the token"
  end
end
