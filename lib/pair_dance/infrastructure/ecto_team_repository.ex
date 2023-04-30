defmodule PairDance.Infrastructure.EctoTeamRepository do

  alias PairDance.Domain.TeamRepository
  alias PairDance.Domain.Team
  alias PairDance.Domain.TeamMember
  alias PairDance.Domain.User

  alias PairDance.Infrastructure.TeamEntity
  alias PairDance.Infrastructure.TeamMemberEntity

  import Ecto.Query, warn: false
  alias PairDance.Repo

  @behaviour TeamRepository

  @impl TeamRepository
  def create(name) do
    {:ok, entity } = %TeamEntity{}
      |> TeamEntity.changeset(%{ name: name })
      |> Repo.insert()
    {:ok, find(entity.id)}
  end

  @impl TeamRepository
  def find(id) do
    entity = Repo.one from t in TeamEntity, where: t.id == ^id, preload: :members
    if entity == nil do
      nil
    else
      from_entity(entity)
    end
  end

  @impl TeamRepository
  def find_all() do
    Repo.all(from t in TeamEntity, preload: [:members]) |> Enum.map(&from_entity/1)
  end

  @impl TeamRepository
  def update(team_id, patch) do
    {:ok, _entity} = TeamEntity.changeset(%TeamEntity{ id: team_id }, patch) |> Repo.update()

    {:ok, find(team_id)}
  end

  @impl TeamRepository
  def delete(id) do
    {:ok, _entity} = Repo.delete(%TeamEntity{ id: id })
    {:ok}
  end

  @impl TeamRepository
  def add_member(team, member) do
    {:ok, _} = %TeamMemberEntity{}
      |> TeamMemberEntity.changeset(%{ name: user_to_string(member.user), team_id: team.id })
      |> Repo.insert()
    {:ok, find(team.id)}
  end

  @spec from_entity(TeamEntity) :: Team.t()
  defp from_entity(entity) do
    %Team{ id: entity.id, name: entity.name, members: entity.members |> Enum.map(&from_member_entity/1) }
  end

  @spec from_member_entity(TeamMemberEntity) :: TeamMember.t()
  defp from_member_entity(entity) do
    %TeamMember{ user: user_from_string(entity.name), role: :admin }
  end

  @spec user_to_string(User.t()) :: String.t()
  defp user_to_string(user) do
    user.id <> "!" <> user.email
  end

  @spec user_from_string(String.t()) :: User.t()
  defp user_from_string(str) do
    case String.split(str, "!") do
      [id, email] -> %User{ id: id, email: email }
      [name] -> %User{ id: name, email: name }
    end

  end
end
