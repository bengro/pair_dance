defmodule PairDance.Domain.User.Repository do

  alias PairDance.Domain.User

  @type user_id :: String.t
  @type email :: String.t

  @callback create_from_email(email()) :: {:ok, User.t()} | {:error, String.t()}

  @callback find_by_id(user_id()) :: User.t() | nil

  @callback find_by_email(email()) :: User.t() | nil

  @callback find_by_email_or_create(email()) :: User.t()

  @callback find_all() :: list(User.t())

  @callback delete_by_id(user_id()) :: {:ok}

  @callback update(User.t(), %{}) :: {:ok, User.t()}
end
