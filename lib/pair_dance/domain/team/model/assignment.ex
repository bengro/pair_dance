defmodule PairDance.Domain.Team.Assignment do
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.Team.Task

  @enforce_keys [:member, :task]
  defstruct [:member, :task]

  @type t() :: %__MODULE__{
          member: Member.t(),
          task: Task.t()
        }
end
