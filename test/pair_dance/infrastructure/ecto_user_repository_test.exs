defmodule PairDance.Infrastructure.EctoUserRepositoryTest do
  use PairDance.DataCase

  alias PairDance.Domain.User
  alias PairDance.Infrastructure.User.EctoRepository, as: Repository

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
    {:ok, %User{ id: id }} = Repository.create_from_email("bob@me.com")

    %User{ email: email} = Repository.find_by_id(id)

    assert email == "bob@me.com"
  end

  test "get a user when does not exist" do
    assert Repository.find_by_id("123e4567-e89b-12d3-a456-426655440000") == nil
  end

  test "delete a user" do
    {:ok, %User{ id: id }} = Repository.create_from_email("bob@me.com")

    {:ok} = Repository.delete_by_id(id)

    assert Repository.find_by_id(id) == nil
  end

  test "list all users" do
    {:ok, _} = Repository.create_from_email("user1@me.com")
    {:ok, _} = Repository.create_from_email("user2@me.com")

    [%User{ email: email}, %User{}] = Repository.find_all()

    assert String.starts_with?(email, "user")
  end

end
