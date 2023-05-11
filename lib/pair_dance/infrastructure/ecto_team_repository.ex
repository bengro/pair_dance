defmodule PairDance.Infrastructure.EctoTeamRepository do

  alias PairDance.Domain.TeamRepository

  alias PairDance.Infrastructure.TeamEntity
  alias PairDance.Infrastructure.TeamMemberEntity
  alias PairDance.Infrastructure.TaskEntity
  alias PairDance.Infrastructure.TaskOwnershipEntity

  import Ecto.Query, warn: false
  alias PairDance.Infrastructure.Repo

  import PairDance.Infrastructure.EntityConverters

  @behaviour TeamRepository

  alias Ecto.UUID

  @impl TeamRepository
  def create(name) do
    {:ok, entity } = %TeamEntity{}
      |> TeamEntity.changeset(%{ name: name, slug: UUID.generate() })
      |> Repo.insert()
    {:ok, find(entity.id)}
  end

  @impl TeamRepository
  def find(id) do
    entity = Repo.one from t in TeamEntity, where: t.id == ^id, preload: [:members, [members: :user], :tasks, :assignments, [assignments: [ :task, :member, member: :user]]]
    if entity == nil do
      nil
    else
      to_team(entity)
    end
  end

  @impl TeamRepository
  def find_by_slug(slug) do
    entity = Repo.one from t in TeamEntity, where: t.slug == ^slug, preload:  [:members, [members: :user], :tasks, :assignments, [assignments: [ :task, :member, member: :user]]]
    if entity == nil do
      nil
    else
      to_team(entity)
    end
  end

  @impl TeamRepository
  def find_all() do
    Repo.all(from t in TeamEntity, preload:  [:members, [members: :user], :tasks, :assignments, [assignments: [ :task, :member, member: :user]]]) |> Enum.map(&to_team/1)
  end

  @impl TeamRepository
  def update(team_id, patch) do
    entity = Repo.one from t in TeamEntity, where: t.id == ^team_id
    case TeamEntity.changeset(entity, patch) |> Repo.update() do
      {:ok, _entity} -> {:ok, find(team_id)}
      {:error, %Ecto.Changeset{ errors: [{:slug, {detail, _} }] } } -> {:error, {:conflict, "slug " <> detail}}
    end


  end

  @impl TeamRepository
  def delete(id) do
    {:ok, _entity} = Repo.delete(%TeamEntity{ id: id })
    {:ok}
  end

  @impl TeamRepository
  def add_member(team, member) do
    {:ok, _} = %TeamMemberEntity{}
      |> TeamMemberEntity.changeset(%{ user_id: member.user.id, team_id: team.id })
      |> Repo.insert()
    {:ok, find(team.id)}
  end

  @impl TeamRepository
  def add_task(team, task_name) do
    {:ok, _} = %TaskEntity{}
      |> TaskEntity.changeset(%{ team_id: team.id, name: task_name })
      |> Repo.insert()
    {:ok, find(team.id)}
  end

  @impl TeamRepository
  def assign_member_to_task(team, assignment) do
    team_id = team.id
    user_id = assignment.member.user.id
    %TeamMemberEntity{ id: member_id } = Repo.one from m in TeamMemberEntity, where: m.team_id == ^team_id and m.user_id == ^user_id
    %TaskOwnershipEntity{ team_id: team.id, member_id: member_id, task_id: assignment.task.id }
      |> Repo.insert()
    {:ok, find(team.id)}
  end

  @impl TeamRepository
  def unassign_member_from_task(team, assignment) do
    team_id = team.id
    user_id = assignment.member.user.id
    task_id = assignment.task.id
    Repo.delete_all from to in TaskOwnershipEntity,
                join: m in TeamMemberEntity,
                on: to.member_id == m.id,
                where: to.team_id == ^team_id and m.user_id == ^user_id and to.task_id ==^task_id
    {:ok, find(team.id)}
  end
end
