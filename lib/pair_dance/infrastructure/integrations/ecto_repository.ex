defmodule PairDance.Infrastructure.Integrations.EctoRepository do
  alias PairDance.Domain.Integration
  alias PairDance.Domain.Integration.Settings
  alias PairDance.Domain.Integration.Credentials

  alias PairDance.Infrastructure.Integrations.Entity

  import Ecto.Query, warn: false
  alias PairDance.Infrastructure.Repo

  def create(team_id, settings) do
    {:ok, entity} =
      %Entity{}
      |> Entity.changeset(%{team_id: team_id, settings: settings})
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
    convert_to_integration(entity)
  end

  def find_by_team_id(team_id) do
    entity = Repo.get_by(Entity, team_id: team_id)
    convert_to_integration(entity)
  end

  def delete(integration) do
    {:ok, _entity} = Repo.delete(%Entity{id: integration.id})
    {:ok}
  end

  defp convert_to_integration(nil) do
    nil
  end

  defp convert_to_integration(entity) do
    %Integration{
      id: entity.id,
      team_id: entity.team_id,
      settings: %Settings{
        board_id: entity.settings["board_id"],
        upcoming_tickets_jql: entity.settings["upcoming_tickets_jql"],
        inprogress_tickets_jql: entity.settings["inprogress_tickets_jql"],
        base_url: entity.settings["base_url"],
        host: entity.settings["host"]
      },
      credentials: %Credentials{
        refresh_token: entity.settings["refresh_token"],
        access_token: entity.settings["access_token"],
        access_token_expiry: entity.settings["access_token_expiry"]
      }
    }
  end
end
