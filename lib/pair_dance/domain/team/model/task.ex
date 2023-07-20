defmodule PairDance.Domain.Team.Task do
  alias PairDance.Domain.Task.Descriptor
  alias PairDance.Domain.Team.AssignedMember

  @enforce_keys [:descriptor, :assigned_members]
  defstruct [:descriptor, :assigned_members]

  @type t() :: %__MODULE__{
          descriptor: Descriptor.t(),
          assigned_members: list(AssignedMember.t())
        }
end
