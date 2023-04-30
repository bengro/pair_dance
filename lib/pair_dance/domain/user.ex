defmodule PairDance.Domain.User do
  @enforce_keys [:id, :name]
  defstruct [:id, :name]

  @type t() :: %__MODULE__{
    id: String.t(),
    name: String.t(),
  }
end
