defmodule PairDance.Domain.Team do
  alias PairDance.Domain.Team.Assignment
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.Team.Task

  @enforce_keys [:id, :name, :slug, :members, :tasks, :assignments]
  defstruct [:id, :name, :slug, :members, :tasks, :assignments]

  @type t() :: %__MODULE__{
          id: integer(),
          name: String.t(),
          slug: String.t(),
          members: list(Member.t()),
          tasks: list(Task.t()),
          assignments: list(Assignment.t())
        }

  def has_member(team, user) do
    Enum.any?(team.members, fn m -> m.user.id == user.id end)
  end
end
