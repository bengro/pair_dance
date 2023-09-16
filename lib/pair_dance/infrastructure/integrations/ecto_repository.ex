defmodule PairDance.Infrastructure.Integrations.EctoRepository do
  alias PairDance.Domain.Integration
  alias PairDance.Infrastructure.Encrypted.Vault

  alias PairDance.Infrastructure.Integrations.Entity

  import Ecto.Query, warn: false
  alias PairDance.Infrastructure.Repo

  def create(settings) do
    #    {:ok, settings_encrypted} = Vault.encrypt(%{"test" => "cool"})

    {:ok, result} =
      %Entity{}
      |> Entity.changeset(%{settings: settings})
      |> Repo.insert()

    {:ok,
     %Integration{
       id: result.id,
       settings: result.settings
     }}
  end
end
