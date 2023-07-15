defmodule PairDance.Domain.User do
  @enforce_keys [:id, :email]
  defstruct [:id, :email, :name, :avatar, :last_login]

  @type t() :: %__MODULE__{
          id: String.t(),
          email: String.t(),
          name: String.t() | nil,
          avatar: String.t() | nil,
          last_login: Phoenix.HTML.Safe.DateTime.t() | nil
        }
end
