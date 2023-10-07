defmodule PairDance.Domain.Integration.Credentials do
  @enforce_keys [:refresh_token, :access_token, :access_token_expiry]
  defstruct [:refresh_token, :access_token, :access_token_expiry]

  @type t() :: %__MODULE__{
          refresh_token: String.t(),
          access_token: String.t(),
          access_token_expiry: Integer.t()
        }
end
