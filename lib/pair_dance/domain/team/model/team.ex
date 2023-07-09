defmodule PairDance.Domain.Team do
  alias PairDance.Domain.Team.Assignment
  alias PairDance.Domain.Team.Descriptor
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.Team.Task

  @enforce_keys [:descriptor, :members, :tasks, :assignments]
  defstruct [:descriptor, :members, :tasks, :assignments]

  @type t() :: %__MODULE__{
          descriptor: Descriptor.t(),
          members: list(Member.t()),
          tasks: list(Task.Descriptor.t()),
          assignments: list(Assignment.t())
        }

  def has_member(team, user) do
    Enum.any?(team.members, fn m -> m.user.id == user.id end)
  end
end
