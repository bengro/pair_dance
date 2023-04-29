defmodule PairDance.Domain.Team do
  @enforce_keys [:id, :name]
  defstruct [:id, :name]

  @type t() :: %__MODULE__{
    name: String.t(),
    id: integer(),
  }
end
