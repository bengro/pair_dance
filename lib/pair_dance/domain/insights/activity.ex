defmodule PairDance.Domain.Insights.Report.Activity do
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.Team.Task

  @enforce_keys [:task, :pairings, :involved_members]
  defstruct [:task, :pairings, :involved_members]

  @type t() :: %__MODULE__{
          task: Task.Descriptor.t(),
          involved_members: Member.t(),
          pairings: List.t()
        }
end
