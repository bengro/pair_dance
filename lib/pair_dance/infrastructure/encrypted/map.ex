defmodule PairDance.Infrastructure.Encrypted.Map do
  use Cloak.Ecto.Map, vault: PairDance.Infrastructure.Encrypted.Vault
end
