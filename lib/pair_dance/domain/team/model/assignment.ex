defmodule PairDance.Domain.Team.Assignment do
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.Team.Task

  @enforce_keys [:member, :task, :assigned_at, :unassigned_at]
  defstruct [:member, :task, :assigned_at, :unassigned_at]

  @type t() :: %__MODULE__{
          member: Member.t(),
          task: Task.t(),
          assigned_at: Date.t(),
          unassigned_at: Date.t()
        }
end
