defmodule PairDance.Domain.Team.AssignedTask do
  alias PairDance.Domain.Team.Task
  alias PairDance.Domain.Team.TimeRange

  @enforce_keys [:task, :time_range]
  defstruct [:task, :time_range]

  @type t() :: %__MODULE__{
          task: Task.Descriptor.t(),
          time_range: TimeRange.t()
        }
end
