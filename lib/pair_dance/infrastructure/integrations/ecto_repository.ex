defmodule PairDance.Infrastructure.Integrations.EctoRepository do
  alias PairDance.Domain.Integration

  alias PairDance.Infrastructure.Integrations.Entity

  import Ecto.Query, warn: false
  alias PairDance.Infrastructure.Repo

  def create(settings) do
    {:ok, entity} =
      %Entity{}
      |> Entity.changeset(%{settings: settings})
      |> Repo.insert()

    {:ok, find_by_id(entity.id)}
  end

  def update_settings(id, settings) do
    integration_entity = Repo.get(Entity, id)

    new_settings =
      integration_entity.settings
      |> Map.merge(settings)

    {:ok, _} =
      integration_entity
      |> Entity.changeset(%{settings: new_settings})
      |> Repo.update()

    {:ok, find_by_id(id)}
  end

  def find_by_id(id) do
    entity = Repo.get(Entity, id)

    %Integration{
      id: entity.id,
      settings: entity.settings
    }
  end
end
