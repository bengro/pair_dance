defmodule PairDance.Domain.Team.Member do

  alias PairDance.Domain.User

  @enforce_keys [:user, :role]
  defstruct [:user, :role]

  @type team_role :: :admin | :user

  @type t() :: %__MODULE__{
    user: User.t(),
    role: team_role(),
  }
end
