defmodule PairDance.Infrastructure.User.EctoRepositoryTest do
  use PairDance.DataCase

  alias PairDance.Domain.User
  alias PairDance.Infrastructure.User.EctoRepository, as: Repository
  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  import PairDance.TeamsFixtures

  test "create a user" do
    {:ok, user} = Repository.create_from_email("bob@example.com")

    assert user.email == "bob@example.com"
  end

  test "emails are unique" do
    {:ok, _} = Repository.create_from_email("bob@example.com")

    {:error, {:conflict, detail}} = Repository.create_from_email("bob@example.com")

    assert detail == "email address already taken"
  end

  test "find or create a user when does not exist" do
    user = Repository.find_by_email_or_create("hi@me.com")

    assert Repository.find_by_email("hi@me.com") == user
  end

  test "find or create a user when already exists" do
    {:ok, existing_user} = Repository.create_from_email("hi@me.com")

    resolved_user = Repository.find_by_email_or_create("hi@me.com")

    assert existing_user == resolved_user
  end

  test "ids are uuids" do
    {:ok, user} = Repository.create_from_email("bob@me.com")

    assert user.id =~ ~r/[0-9a-f]{8}-/i
  end

  test "get a user by id" do
    {:ok, %User{id: id}} = Repository.create_from_email("bob@me.com")

    %User{email: email} = Repository.find_by_id(id)

    assert email == "bob@me.com"
  end

  test "get a user when does not exist" do
    assert Repository.find_by_id("123e4567-e89b-12d3-a456-426655440000") == nil
  end

  test "delete a user" do
    {:ok, %User{id: id}} = Repository.create_from_email("bob@me.com")

    {:ok} = Repository.delete_by_id(id)

    assert Repository.find_by_id(id) == nil
  end

  test "list all users" do
    {:ok, _} = Repository.create_from_email("user1@me.com")
    {:ok, _} = Repository.create_from_email("user2@me.com")

    [%User{email: email}, %User{}] = Repository.find_all()

    assert String.starts_with?(email, "user")
  end

  test "last active team id can be set, and is null when team is deleted" do
    team = create_team(%{member_names: ["ana"], task_names: ["my task"]})

    {:ok, user} = Repository.create_from_email("user1@me.com")

    {:ok, user_with_active_team} =
      Repository.update(user, %{last_active_team_id: team.descriptor.id})

    assert user_with_active_team.last_active_team_id == team.descriptor.id

    TeamRepository.delete(team.descriptor.id)

    user_with_active_team = Repository.find_by_id(user_with_active_team.id)
    assert user_with_active_team.last_active_team_id == nil
  end
end
