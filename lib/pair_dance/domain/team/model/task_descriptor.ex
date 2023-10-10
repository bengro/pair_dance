defmodule PairDance.Domain.Team.Task.Descriptor do
  @enforce_keys [:id, :name]
  defstruct [:id, :name, :is_imported, :external_id]

  @type t() :: %__MODULE__{
          id: integer(),
          name: String.t(),
          external_id: String.t(),
          is_imported: Boolean.t()
        }
end
