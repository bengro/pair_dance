defmodule PairDance.Domain.Team.Descriptor do
  @enforce_keys [:id, :name, :slug]
  defstruct [:id, :name, :slug]

  @type t() :: %__MODULE__{
          id: integer(),
          name: String.t(),
          slug: String.t()
        }
end
