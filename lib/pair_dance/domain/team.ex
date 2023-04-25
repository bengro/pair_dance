defmodule PairDance.Domain.Team do
  defstruct [:name]

  @type t() :: %__MODULE__{
    name: String.t(),
  }
end
