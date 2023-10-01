defmodule PairDance.Infrastructure.Integrations.EctoRepositoryTest do
  use PairDance.DataCase

  alias PairDance.Infrastructure.Integrations.EctoRepository, as: Repository
  alias PairDance.Domain.Integration

  import PairDance.TeamsFixtures

  defp setup_data(_) do
    team = create_team(%{member_names: ["ana"], task_names: ["my task"]})
    %{team_id: team.descriptor.id}
  end

  setup [:setup_data]

  test "create an integration", %{team_id: team_id} do
    {:ok, integration} = Repository.create(team_id, %{refresh_token: "the token"})

    assert %Integration{id: id, team_id: team_id} = integration
    assert id
    assert team_id
    assert integration.credentials.refresh_token == "the token"
  end

  test "configure the integration", %{team_id: team_id} do
    {:ok, %Integration{id: id}} = Repository.create(team_id, %{refresh_token: "the token"})

    {:ok, integration} =
      Repository.update_settings(id, %{board_id: 123, backlog_query: "jql query"})

    assert integration.settings.board_id == 123
    assert integration.settings.backlog_query == "jql query"
    assert integration.credentials.refresh_token == "the token"
  end

  test "find integration by team id", %{team_id: team_id} do
    {:ok, created_integration} = Repository.create(team_id, %{refresh_token: "the token"})

    retrieved_integration = Repository.find_by_team_id(team_id)

    assert created_integration == retrieved_integration
  end

  test "does not throw if team_id non-existant" do
    retrieved_integration = Repository.find_by_team_id(1)

    assert retrieved_integration == nil
  end
end
