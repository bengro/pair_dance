defmodule PairDance.Domain.UserRepository do

  alias PairDance.Domain.User

  @type user_id :: String.t

  @callback create(String.t()) :: {:ok, User.t()}

  @callback find(user_id()) :: User.t() | nil

  @callback find_all() :: list(User.t())

  @callback delete(user_id()) :: {:ok}
end
