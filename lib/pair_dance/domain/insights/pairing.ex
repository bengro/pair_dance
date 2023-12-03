defmodule PairDance.Domain.Insights.Report.Pairing do
  alias PairDance.Domain.Team.Member

  @enforce_keys [:pair1, :pair2, :duration_days]
  defstruct [:pair1, :pair2, :duration_days]

  @type t() :: %__MODULE__{
          pair1: Member.t(),
          pair2: Member.t(),
          duration_days: Integer.t()
        }
end
