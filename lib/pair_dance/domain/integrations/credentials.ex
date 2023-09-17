defmodule PairDance.Domain.Integration.Credentials do
  @enforce_keys [:refresh_token]
  defstruct [:refresh_token]

  @type t() :: %__MODULE__{
          refresh_token: String.t()
        }
end
