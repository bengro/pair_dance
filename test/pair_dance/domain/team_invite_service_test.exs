defmodule PairDance.Domain.Team.InviteServiceTest do
  use PairDance.DataCase

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Domain.Team.InviteService
  alias PairDance.Domain.Team

  test "invite a new user to the team" do
    {:ok, team} = TeamRepository.create("pair dance")

    team = InviteService.invite(team, "bobby@pair.dance")

    assert %Team{members: [member]} = team
    assert member.user.email == "bobby@pair.dance"
    assert TeamRepository.find(team.id) == team
  end
end
