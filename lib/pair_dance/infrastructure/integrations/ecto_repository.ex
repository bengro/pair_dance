defmodule PairDance.Infrastructure.Integrations.EctoRepository do
  alias PairDance.Domain.Integration
  alias PairDance.Domain.Integration.Settings
  alias PairDance.Domain.Integration.Credentials

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
    %Entity{id: id, settings: settings} = Repo.get(Entity, id)

    %Integration{
      id: id,
      settings: %Settings{
        board_id: settings["board_id"],
        backlog_query: settings["backlog_query"]
      },
      credentials: %Credentials{refresh_token: settings["refresh_token"]}
    }
  end
end
