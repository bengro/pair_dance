defmodule PairDance.Domain.User.LoginService do
  alias PairDance.Domain.User
  alias PairDance.Infrastructure.User.EctoRepository, as: UserRepository

  @spec login(String.t(), String.t(), String.t()) :: User.t()
  def login(email, name, avatar) do
    user = UserRepository.find_by_email_or_create(email)

    {:ok, updated_user} = UserRepository.update(user, %{name: name, avatar: avatar})

    updated_user
  end
end
