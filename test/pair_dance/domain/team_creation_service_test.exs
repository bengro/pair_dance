defmodule PairDance.Domain.Team.TeamServiceTest do
  use PairDance.DataCase

  alias PairDance.Domain.Team
  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.User.EctoRepository, as: UserRepository

  defp setup_data(_) do
    {:ok, user} = UserRepository.create_from_email("bob@gmail.com")
    %{user: user}
  end

  setup [:setup_data]

  test "teams are persisted", %{user: user} do
    {:ok, team} = Team.TeamService.new_team("infra", user)

    assert team == TeamRepository.find(team.descriptor.id)
  end

  test "teams are created with simple URL slugs", %{user: user} do
    {:ok, team} = Team.TeamService.new_team("infra", user)

    assert team.descriptor.slug == "infra"
  end

  test "teams have uuids as slugs in case of name conflicts", %{user: user} do
    {:ok, _} = Team.TeamService.new_team("infra", user)
    {:ok, team} = Team.TeamService.new_team("infra", user)

    assert team.descriptor.slug =~ ~r/[0-9a-f]{8}-/i
  end

  test "the team creator gets added as member", %{user: user} do
    {:ok, %Team{members: members}} = Team.TeamService.new_team("infra", user)

    [member] = members

    assert member.user == user
    assert member.role == :admin
    assert member.available == true
  end
end
