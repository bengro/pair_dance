defmodule PairDance.Infrastructure.Jira.JiraTicket do
  @enforce_keys [:id, :name]
  defstruct [:id, :name]

  @type t() :: %__MODULE__{
          id: integer,
          name: String.t()
        }
end
