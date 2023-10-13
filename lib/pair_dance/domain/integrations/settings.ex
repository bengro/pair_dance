defmodule PairDance.Domain.Integration.Settings do
  @enforce_keys [:base_url, :host, :board_id, :upcoming_tickets_jql, :inprogress_tickets_jql]
  defstruct [:base_url, :host, :board_id, :upcoming_tickets_jql, :inprogress_tickets_jql]

  @type t() :: %__MODULE__{
          base_url: String.t(),
          host: String.t(),
          board_id: String.t(),
          upcoming_tickets_jql: String.t(),
          inprogress_tickets_jql: String.t()
        }
end
