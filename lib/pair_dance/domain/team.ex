defmodule PairDance.Domain.Team do

  alias PairDance.Domain.TeamMember
  alias PairDance.Domain.Task

  @enforce_keys [:id, :name, :slug, :members, :tasks]
  defstruct [:id, :name, :slug, :members, :tasks]

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    slug: String.t(),
    members: list(TeamMember.t()),
    tasks: list(Task.t())
  }

  def has_member(team, user) do
    Enum.any?(team.members, fn m -> m.user.id == user.id end)
  end
end
