defmodule PairDance.Domain.Team.Assignment do
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.Team.Task
  alias PairDance.Domain.Team.TimeRange

  @enforce_keys [:member, :task, :time_range]
  defstruct [:member, :task, :time_range]

  @type t() :: %__MODULE__{
          member: Member.t(),
          task: Task.t(),
          time_range: TimeRange.t()
        }
end
