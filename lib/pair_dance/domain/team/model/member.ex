defmodule PairDance.Domain.Team.Member do
  alias PairDance.Domain.User

  @enforce_keys [:user, :role]
  defstruct [:id, :user, :role, :available]

  @type team_role :: :admin | :user

  @type t() :: %__MODULE__{
          id: String.t(),
          user: User.t(),
          role: team_role(),
          available: boolean
        }
end
