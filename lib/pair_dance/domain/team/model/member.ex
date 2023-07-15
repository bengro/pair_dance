defmodule PairDance.Domain.Team.Member do
  alias PairDance.Domain.User

  @enforce_keys [:user, :role]
  defstruct [:id, :user, :role, :available, :last_login]

  @type team_role :: :admin | :user

  @type t() :: %__MODULE__{
          id: String.t(),
          user: User.t(),
          role: team_role(),
          available: boolean,
          last_login: Phoenix.HTML.Safe.DateTime.t()
        }
end
