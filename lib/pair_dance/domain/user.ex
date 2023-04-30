defmodule PairDance.Domain.User do
  @enforce_keys [:id, :email]
  defstruct [:id, :email]

  @type t() :: %__MODULE__{
    id: String.t(),
    email: String.t(),
  }
end
