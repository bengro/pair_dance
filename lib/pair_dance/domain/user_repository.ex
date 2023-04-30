defmodule PairDance.Domain.UserRepository do

  alias PairDance.Domain.User

  @type user_id :: String.t

  @callback create(String.t()) :: {:ok, User.t()}

  @callback find(user_id()) :: User.t() | nil
end
