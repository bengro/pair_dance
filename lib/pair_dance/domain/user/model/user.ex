defmodule PairDance.Domain.User do
  @enforce_keys [:id, :email]
  defstruct [
    :id,
    :email,
    :name,
    :approximate_name,
    :avatar,
    :last_login,
    :last_active_team_id,
    :initials
  ]

  @type t() :: %__MODULE__{
          id: String.t(),
          email: String.t(),
          name: String.t() | nil,
          approximate_name: String.t() | nil,
          avatar: String.t() | nil,
          last_login: Phoenix.HTML.Safe.DateTime.t() | nil,
          last_active_team_id: integer() | nil,
          initials: String.t() | nil
        }
end
