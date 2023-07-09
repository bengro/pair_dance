defmodule PairDance.Infrastructure.Team.EctoRepositoryTest do
  use PairDance.DataCase

  alias PairDance.Domain.Team.Assignment
  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.Team.Task
  alias PairDance.Domain.User
  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.User.EctoRepository, as: UserRepository

  import PairDance.TeamsFixtures

  test "create a team" do
    {:ok, team} = TeamRepository.create("comet")

    assert team.descriptor.name == "comet"
  end

  test "teams are created with uuid slugs" do
    {:ok, team} = TeamRepository.create("pair dance")

    assert team.descriptor.slug =~ ~r/[0-9a-f]{8}-/i
  end

  test "get a team by id" do
    {:ok, %Team{descriptor: %Team.Descriptor{id: id}}} = TeamRepository.create("comet")

    team = TeamRepository.find(id)

    assert team != nil
    assert team.descriptor.name == "comet"
  end

  test "get a team by slug" do
    {:ok, %Team{descriptor: %Team.Descriptor{slug: slug}}} = TeamRepository.create("comet")

    team = TeamRepository.find_by_slug?(slug)

    assert team != nil
    assert team.descriptor.name == "comet"
  end

  test "get a non-existing team" do
    assert TeamRepository.find(-1) == nil
  end

  test "list teams of a member" do
    {:ok, team} = TeamRepository.create("team 1")
    {:ok, user} = UserRepository.create_from_email("bob@me.com")

    {:ok, _} = TeamRepository.add_member(team, %Member{user: user, role: :admin})

    teams = TeamRepository.find_by_member(user.id)

    [%Team{members: [%Member{user: %User{id: user_id}}]}] = teams

    assert user.id == user_id
  end

  test "list teams of a member when there are deleted tasks" do
    team =
      create_team(%{member_names: ["ana"], task_names: ["my task"]})
      |> create_assignment("my task", "ana")

    [task] = team.tasks

    TeamRepository.delete_task(team, task)
    teams = TeamRepository.find_by_member(Enum.at(team.members, 0).user.id)

    assert length(teams) == 1
  end

  test "update team name" do
    {:ok, team} = TeamRepository.create("original name")

    {:ok, _} = TeamRepository.update(team.descriptor.id, %{name: "new name"})
    team = TeamRepository.find(team.descriptor.id)

    assert team.descriptor.name == "new name"
  end

  test "update team slug" do
    {:ok, team} = TeamRepository.create("comet")

    {:ok, _} = TeamRepository.update(team.descriptor.id, %{slug: "my-slug"})
    team = TeamRepository.find_by_slug?("my-slug")

    assert team.descriptor.name == "comet"
  end

  test "slugs must be unique" do
    {:ok, team1} = TeamRepository.create("team 1")
    {:ok, team2} = TeamRepository.create("team 2")

    {:error, {:conflict, detail}} =
      TeamRepository.update(team2.descriptor.id, %{slug: team1.descriptor.slug})

    assert detail =~ "slug has already been taken"
  end

  test "delete a team" do
    {:ok, team} = TeamRepository.create("comet")

    {:ok} = TeamRepository.delete(team.descriptor.id)

    assert TeamRepository.find(team.descriptor.id) == nil
  end

  describe "members" do
    test "add a new member" do
      {:ok, team} = TeamRepository.create("comet")
      {:ok, user} = UserRepository.create_from_email("bob@me.com")

      {:ok, updated_team} = TeamRepository.add_member(team, %Member{user: user, role: :admin})

      [member] = updated_team.members
      assert member.user == user
      assert member.role == :admin
      assert member.available == true

      assert updated_team == TeamRepository.find(team.descriptor.id)
    end
  end

  describe "tasks" do
    test "new teams do not have any tasks" do
      {:ok, team} = TeamRepository.create("comet")

      assert team.tasks == []
    end

    test "create a task" do
      {:ok, team} = TeamRepository.create("comet")

      {:ok, updated_team} = TeamRepository.add_task(team, "login with google")

      assert [%Task{name: name}] = updated_team.tasks
      assert name == "login with google"
      assert updated_team == TeamRepository.find(team.descriptor.id)
    end

    test "delete a task with assignments" do
      {:ok, team} = TeamRepository.create("comet")
      {:ok, user} = UserRepository.create_from_email("bob@me.com")

      {:ok, %Team{members: [member]}} =
        TeamRepository.add_member(team, %Member{user: user, role: :admin})

      {:ok, %Team{tasks: [task]}} = TeamRepository.add_task(team, "login with google")

      {:ok, _} = TeamRepository.assign_member_to_task(team, member, task)

      TeamRepository.delete_task(team, task)
      team = TeamRepository.find(team.descriptor.id)

      assert team.tasks == []
      assert team.assignments == []
    end
  end

  describe "assignments" do
    test "assign a member to a task" do
      {:ok, team} = TeamRepository.create("comet")
      {:ok, user} = UserRepository.create_from_email("bob@me.com")

      {:ok, %Team{members: [member]}} =
        TeamRepository.add_member(team, %Member{user: user, role: :admin})

      {:ok, %Team{tasks: [task]}} = TeamRepository.add_task(team, "login with google")

      {:ok, updated_team} = TeamRepository.assign_member_to_task(team, member, task)

      assert [%Assignment{member: ^member, task: ^task}] = updated_team.assignments
      assert updated_team == TeamRepository.find(team.descriptor.id)
    end

    test "unassign a member from a task" do
      {:ok, team} = TeamRepository.create("comet")
      {:ok, user} = UserRepository.create_from_email("bob@me.com")

      {:ok, %Team{members: [member]}} =
        TeamRepository.add_member(team, %Member{user: user, role: :admin})

      {:ok, %Team{tasks: [task]}} = TeamRepository.add_task(team, "login with google")

      TeamRepository.assign_member_to_task(team, member, task)

      {:ok, updated_team} = TeamRepository.unassign_member_from_task(team, member, task)

      assert updated_team.assignments == []
      assert updated_team == TeamRepository.find(team.descriptor.id)
    end

    test "mark member unavailable and available" do
      team =
        create_team(%{
          member_names: ["ana"],
          task_names: []
        })

      [member] = team.members
      assert member.available == true

      {:ok, %Team{members: [available_member | _]}} =
        TeamRepository.mark_member_unavailable(team, Enum.at(team.members, 0))

      assert available_member.available == false

      {:ok, %Team{members: [unavailable_member | _]}} =
        TeamRepository.mark_member_available(team, Enum.at(team.members, 0))

      assert unavailable_member.available == true
    end
  end
end
