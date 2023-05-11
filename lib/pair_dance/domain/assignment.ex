defmodule PairDance.Domain.Assignment do

  alias PairDance.Domain.TeamMember
  alias PairDance.Domain.Task

  @enforce_keys [:member, :task]
  defstruct [:member, :task]

  @type t() :: %__MODULE__{
    member: TeamMember.t(),
    task: Task.t(),
  }
end
