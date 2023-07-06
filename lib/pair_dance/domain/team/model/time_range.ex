defmodule PairDance.Domain.Team.TimeRange do
  @enforce_keys [:start, :end]
  defstruct [:start, :end]

  @type t() :: %__MODULE__{
          start: DateTime.t(),
          end: DateTime.t()
        }
end
