defmodule PairDance.Infrastructure.EctoUserRepositoryTest do
  use PairDance.DataCase

  alias PairDance.Domain.User
  alias PairDance.Infrastructure.EctoUserRepository

  test "create a user" do
    {:ok, user} = EctoUserRepository.create("Bob")

    assert user.name == "Bob"
  end

  test "ids are uuids" do
    {:ok, user} = EctoUserRepository.create("Bob")

    assert user.id =~ ~r/[0-9a-f]{8}-/i
  end

  test "get a user by id" do
    {:ok, %User{ id: id }} = EctoUserRepository.create("Bob")

    %User{ name: name } = EctoUserRepository.find_by_id(id)

    assert name == "Bob"
  end

  test "get a user when does not exist" do
    assert EctoUserRepository.find_by_id("123e4567-e89b-12d3-a456-426655440000") == nil
  end

  test "delete a user" do
    {:ok, %User{ id: id }} = EctoUserRepository.create("Bob")

    {:ok} = EctoUserRepository.delete(id)

    assert EctoUserRepository.find_by_id(id) == nil
  end

  test "list all users" do
    {:ok, _} = EctoUserRepository.create("user 1")
    {:ok, _} = EctoUserRepository.create("user 2")

    [%User{ name: name }, %User{}] = EctoUserRepository.find_all()

    assert String.starts_with?(name, "user")
  end

end
