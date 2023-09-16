defmodule PairDance.Infrastructure.Encrypted.Binary do
  use Cloak.Ecto.Binary, vault: PairDance.Infrastructure.Encrypted.Vault
end
