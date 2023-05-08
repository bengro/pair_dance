defmodule PairDance.Domain.UserServiceTest do
  use PairDance.DataCase

  alias PairDance.Domain.User
  alias PairDance.Domain.UserService
  alias PairDance.Infrastructure.EctoUserRepository, as: UserRepository

  test "first time login" do
    user = UserService.login("bob@me.com", "Bob Dylan", "http://avatar.com")
    %User{ id: id, email: email, name: name, avatar: avatar } = user

    assert email == "bob@me.com"
    assert name == "Bob Dylan"
    assert avatar == "http://avatar.com"
    assert user == UserRepository.find_by_id(id)
  end

  test "first time login of an invited user" do
    UserRepository.create_from_email("bob@me.com")

    user = UserService.login("bob@me.com", "Bob Dylan", "http://avatar.com")
    %User{ id: id, email: email, name: name, avatar: avatar } = user

    assert email == "bob@me.com"
    assert name == "Bob Dylan"
    assert avatar == "http://avatar.com"
    assert user == UserRepository.find_by_id(id)
  end

end
