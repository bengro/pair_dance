defmodule PairDance.Domain.Integration do
  @enforce_keys [:id, :settings]
  defstruct [:id, :settings]

  @type t() :: %__MODULE__{
          id: String.t(),
          settings: Map.t()
        }
end
