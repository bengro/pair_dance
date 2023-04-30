defmodule PairDance.Domain.TeamInviteServiceTest do
  use PairDance.DataCase

  alias PairDance.Infrastructure.EctoTeamRepository, as: TeamRepository
  alias PairDance.Domain.TeamInviteService
  alias PairDance.Domain.Team

  test "invite a new user to the team" do
    {:ok, team } = TeamRepository.create("pair dance")

    team = TeamInviteService.invite(team, "bobby@pair.dance")

    assert %Team{ members: [member] } = team
    assert member.user.email == "bobby@pair.dance"
    assert TeamRepository.find(team.id) == team
  end

end
