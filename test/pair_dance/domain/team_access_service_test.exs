defmodule PairDance.Domain.Team.AccessServiceTest do
  use PairDance.DataCase

  alias PairDance.Domain.Team.AccessService
  alias PairDance.Domain.Team.TeamService
  alias PairDance.Infrastructure.User.EctoRepository, as: UserRepository

  test "members have access" do
    {:ok, user} = UserRepository.create_from_email("bob@gmail.com")
    {:ok, _} = TeamService.new_team("infra", user)

    assert AccessService.check_access("infra", user) == true
  end

  test "non-members do not have access" do
    {:ok, owner} = UserRepository.create_from_email("bob@gmail.com")
    {:ok, _} = TeamService.new_team("infra", owner)
    {:ok, non_member} = UserRepository.create_from_email("charlie@gmail.com")

    assert AccessService.check_access("infra", non_member) == false
  end

  test "no access when slug does not exist" do
    {:ok, user} = UserRepository.create_from_email("bob@gmail.com")

    assert AccessService.check_access("never-existed", user) == false
  end
end
