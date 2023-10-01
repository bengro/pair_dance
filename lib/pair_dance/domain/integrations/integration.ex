defmodule PairDance.Domain.Integration do
  alias PairDance.Domain.Integration.Settings
  alias PairDance.Domain.Integration.Credentials

  @enforce_keys [:id, :team_id, :settings, :credentials]
  defstruct [:id, :team_id, :settings, :credentials]

  @type t() :: %__MODULE__{
          id: String.t(),
          team_id: String.t(),
          settings: Settings.t(),
          credentials: Credentials.t()
        }
end
