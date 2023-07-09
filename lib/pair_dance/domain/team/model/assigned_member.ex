defmodule PairDance.Domain.Team.AssignedMember do
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.Team.TimeRange

  @enforce_keys [:member, :time_range]
  defstruct [:member, :time_range]

  @type t() :: %__MODULE__{
          member: Member.t(),
          time_range: TimeRange.t()
        }
end
