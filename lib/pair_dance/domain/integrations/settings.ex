defmodule PairDance.Domain.Integration.Settings do
  @enforce_keys [:base_url, :host, :board_id, :backlog_query]
  defstruct [:base_url, :host, :board_id, :backlog_query]

  @type t() :: %__MODULE__{
          base_url: String.t(),
          host: String.t(),
          board_id: String.t(),
          backlog_query: String.t()
        }
end
