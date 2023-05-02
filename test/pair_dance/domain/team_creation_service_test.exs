defmodule PairDance.Domain.TeamCreationServiceTest do
  use PairDance.DataCase

  alias PairDance.Domain.TeamCreationService
  alias PairDance.Infrastructure.EctoTeamRepository, as: TeamRepository

  test "teams are persisted" do
    {:ok, team} = TeamCreationService.new_team("infra")

    assert team == TeamRepository.find(team.id)
  end

  test "teams are created with simple URL slugs" do
    {:ok, team} = TeamCreationService.new_team("infra")

    assert team.slug == "infra"
  end

  test "teams have uuids as slugs in case of name conflicts" do
    {:ok, _} = TeamCreationService.new_team("infra")
    {:ok, team} = TeamCreationService.new_team("infra")

    assert team.slug =~ ~r/[0-9a-f]{8}-/i
  end

end
