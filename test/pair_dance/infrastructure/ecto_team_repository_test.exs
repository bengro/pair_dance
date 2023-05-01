defmodule PairDance.Infrastructure.EctoTeamRepositoryTest do
  use PairDance.DataCase

  alias PairDance.Domain.Team
  alias PairDance.Domain.TeamMember
  alias PairDance.Infrastructure.EctoTeamRepository, as: TeamRepository
  alias PairDance.Infrastructure.EctoUserRepository, as: UserRepository

  test "create a team" do
    {:ok, team} = TeamRepository.create("comet")

    assert team.name == "comet"
  end

  test "teams are created with uuid slugs" do
    {:ok, team} = TeamRepository.create("pair dance")

    assert team.slug =~ ~r/[0-9a-f]{8}-/i
  end

  test "get a team by id" do
    {:ok, %Team{ id: id }} = TeamRepository.create("comet")

    team = TeamRepository.find(id)

    assert team != nil
    assert team.name == "comet"
  end


  test "get a non-existing team" do
    assert TeamRepository.find(-1) == nil
  end

  test "list all teams" do
    {:ok, _} = TeamRepository.create("team 1")
    {:ok, _} = TeamRepository.create("team 2")

    [%Team{ name: name }, %Team{}] = TeamRepository.find_all()

    assert String.starts_with?(name, "team")
  end

  test "update a team" do
    {:ok, team} = TeamRepository.create("original name")

    {:ok, _} = TeamRepository.update(team.id, %{name: "new name"})
    %Team{name: name} = TeamRepository.find(team.id)

    assert name == "new name"
  end

  test "delete a team" do
    {:ok, %Team{ id: id }} = TeamRepository.create("comet")

    {:ok} = TeamRepository.delete(id)

    assert TeamRepository.find(id) == nil
  end

  describe "members" do

    test "add a new member" do
      {:ok, team} = TeamRepository.create("comet")
      {:ok, user} = UserRepository.create_from_email("bob@me.com")

      {:ok, updated_team} = TeamRepository.add_member(team, %TeamMember{ user: user, role: :admin})

      assert updated_team.members == [%TeamMember{ user: user, role: :admin}]
      assert updated_team == TeamRepository.find(team.id)
    end

  end

end
