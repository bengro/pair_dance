defmodule PairDance.Infrastructure.EctoTeamRepository do

  alias PairDance.Domain.TeamRepository
  alias PairDance.Domain.Team

  alias PairDance.Teams.Team, as: TeamEntity

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

  @spec from_entity(TeamEntity) :: Team.t()
  defp from_entity(entity) do
    %Team{ id: entity.id, name: entity.name }
  end
end
