defmodule PairDance.Domain.UserRepository do

  alias PairDance.Domain.User

  @type user_id :: String.t
  @type email :: String.t

  @callback create(email()) :: {:ok, User.t()} | {:error, String.t()}

  @callback find_by_id(user_id()) :: User.t() | nil

  @callback find_by_email(email()) :: User.t() | nil

  @callback find_or_create(email()) :: User.t()

  @callback find_all() :: list(User.t())

  @callback delete(user_id()) :: {:ok}
end
