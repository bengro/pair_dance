defmodule PairDance.Infrastructure.EctoTeamRepository do

  alias PairDance.Domain.TeamRepository
  alias PairDance.Domain.Team

  alias PairDance.Infrastructure.TeamEntity

  import Ecto.Query, warn: false
  alias PairDance.Repo

  @behaviour TeamRepository

  @impl TeamRepository
  def create(name) do
    {:ok, entity } = %TeamEntity{}
      |> TeamEntity.changeset(%{ name: name })
      |> Repo.insert()
    {:ok, from_entity(entity)}
  end

  @impl TeamRepository
  def find(id) do
    entity = Repo.get(TeamEntity, id)
    if entity == nil do
      nil
    else
      from_entity(entity)
    end
  end

  @impl TeamRepository
  def find_all() do
    Repo.all(TeamEntity)
    |> Enum.map(fn entity -> %Team{ id: entity.id, name: entity.name } end)
  end

  @impl TeamRepository
  def update(team_id, patch) do
    {:ok, entity} = TeamEntity.changeset(%TeamEntity{ id: team_id }, patch) |> Repo.update()
    {:ok, from_entity(entity)}
  end

  @impl TeamRepository
  def delete(id) do
    {:ok, _entity} = Repo.delete(%TeamEntity{ id: id })
    {:ok}
  end

  @spec from_entity(TeamEntity) :: Team.t()
  defp from_entity(entity) do
    %Team{ id: entity.id, name: entity.name }
  end
end
