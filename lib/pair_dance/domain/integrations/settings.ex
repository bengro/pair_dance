defmodule PairDance.Domain.Integration.Settings do
  @enforce_keys [:board_id, :backlog_query]
  defstruct [:board_id, :backlog_query]

  @type t() :: %__MODULE__{
          board_id: String.t(),
          backlog_query: String.t()
        }
end
