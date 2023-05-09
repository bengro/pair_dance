defmodule PairDance.Domain.TeamAccessServiceTest do
  use PairDance.DataCase

  alias PairDance.Domain.TeamAccessService
  alias PairDance.Domain.TeamCreationService
  alias PairDance.Infrastructure.EctoUserRepository, as: UserRepository

  test "members have access" do
    {:ok, user} = UserRepository.create_from_email("bob@gmail.com")
    {:ok, _} = TeamCreationService.new_team("infra", user)

    assert TeamAccessService.check_access("infra", user) == true
  end

  test "non-members do not have access" do
    {:ok, owner} = UserRepository.create_from_email("bob@gmail.com")
    {:ok, _} = TeamCreationService.new_team("infra", owner)
    {:ok, non_member} = UserRepository.create_from_email("charlie@gmail.com")

    assert TeamAccessService.check_access("infra", non_member) == false
  end

  test "no access when slug does not exist" do
    {:ok, user} = UserRepository.create_from_email("bob@gmail.com")

    assert TeamAccessService.check_access("never-existed", user) == false
  end

end
