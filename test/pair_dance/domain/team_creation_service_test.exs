defmodule PairDance.Domain.TeamCreationServiceTest do
  use PairDance.DataCase

  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Member

  alias PairDance.Domain.TeamCreationService
  alias PairDance.Infrastructure.EctoTeamRepository, as: TeamRepository
  alias PairDance.Infrastructure.EctoUserRepository, as: UserRepository

  defp setup_data(_) do
    {:ok, user} = UserRepository.create_from_email("bob@gmail.com")
    %{user: user}
  end

  setup [:setup_data]

  test "teams are persisted", %{user: user} do
    {:ok, team} = TeamCreationService.new_team("infra", user)

    assert team == TeamRepository.find(team.id)
  end

  test "teams are created with simple URL slugs", %{user: user} do
    {:ok, team} = TeamCreationService.new_team("infra", user)

    assert team.slug == "infra"
  end

  test "teams have uuids as slugs in case of name conflicts", %{user: user} do
    {:ok, _} = TeamCreationService.new_team("infra", user)
    {:ok, team} = TeamCreationService.new_team("infra", user)

    assert team.slug =~ ~r/[0-9a-f]{8}-/i
  end

  test "the team creator gets added as member", %{user: user} do
    {:ok, %Team{members: members}} = TeamCreationService.new_team("infra", user)

    assert [%Member{ user: user, role: :admin}] == members
  end

end
