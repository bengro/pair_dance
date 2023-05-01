defmodule PairDance.Domain.Team do

  alias PairDance.Domain.TeamMember

  @enforce_keys [:id, :name, :slug, :members]
  defstruct [:id, :name, :slug, :members]

  @type t() :: %__MODULE__{
    id: integer(),
    name: String.t(),
    slug: String.t(),
    members: list(TeamMember.t())
  }
end
