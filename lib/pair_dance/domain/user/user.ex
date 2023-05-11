defmodule PairDance.Domain.User do
  @enforce_keys [:id, :email]
  defstruct [:id, :email, :name, :avatar]

  @type t() :: %__MODULE__{
    id: String.t(),
    email: String.t(),
    name: String.t() | nil,
    avatar: String.t() | nil,
  }
end
