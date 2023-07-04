defmodule PairDance.Infrastructure.Team.EctoRepository do
  alias PairDance.Domain.Team

  alias PairDance.Infrastructure.TeamEntity
  alias PairDance.Infrastructure.Team.MemberEntity
  alias PairDance.Infrastructure.Team.TaskEntity
  alias PairDance.Infrastructure.Team.AssignmentEntity

  import Ecto.Query, warn: false
  alias PairDance.Infrastructure.Repo

  import PairDance.Infrastructure.EntityConverters

  @behaviour Team.Repository

  alias Ecto.UUID

  @impl Team.Repository
  def create(name) do
    {:ok, entity} =
      %TeamEntity{}
      |> TeamEntity.changeset(%{name: name, slug: UUID.generate()})
      |> Repo.insert()

    {:ok, find(entity.id)}
  end

  @impl Team.Repository
  def find(id) do
    entity =
      Repo.one(
        from t in TeamEntity,
          where: t.id == ^id,
          preload: [
            :members,
            [members: :user],
            :tasks,
            :assignments,
            [assignments: [:task, :member, member: :user]]
          ]
      )

    if entity == nil do
      nil
    else
      to_team(entity)
    end
  end

  @impl Team.Repository
  def find_by_member(member_id) do
    Repo.all(
      from t in TeamEntity,
        join: m in MemberEntity,
        on: t.id == m.team_id,
        where: m.user_id == ^member_id,
        preload: [
          :members,
          [members: :user],
          :tasks,
          :assignments,
          [assignments: [:task, :member, member: :user]]
        ]
    )
    |> Enum.map(&to_team/1)
  end

  @impl Team.Repository
  def find_by_slug?(slug) do
    entity =
      Repo.one(
        from t in TeamEntity,
          where: t.slug == ^slug,
          preload: [
            :members,
            [members: :user],
            :tasks,
            :assignments,
            [assignments: [:task, :member, member: :user]]
          ]
      )

    if entity == nil do
      nil
    else
      to_team(entity)
    end
  end

  @impl Team.Repository
  def find_all() do
    Repo.all(
      from t in TeamEntity,
        preload: [
          :members,
          [members: :user],
          :tasks,
          :assignments,
          [assignments: [:task, :member, member: :user]]
        ]
    )
    |> Enum.map(&to_team/1)
  end

  @impl Team.Repository
  def update(team_id, patch) do
    entity = Repo.one(from t in TeamEntity, where: t.id == ^team_id)

    case TeamEntity.changeset(entity, patch) |> Repo.update() do
      {:ok, _entity} ->
        {:ok, find(team_id)}

      {:error, %Ecto.Changeset{errors: [{:slug, {detail, _}}]}} ->
        {:error, {:conflict, "slug " <> detail}}
    end
  end

  @impl Team.Repository
  def delete(id) do
    {:ok, _entity} = Repo.delete(%TeamEntity{id: id})
    {:ok}
  end

  @impl Team.Repository
  def add_member(team, member) do
    {:ok, _} =
      %MemberEntity{}
      |> MemberEntity.changeset(%{user_id: member.user.id, team_id: team.id})
      |> Repo.insert()

    {:ok, find(team.id)}
  end

  @impl Team.Repository
  def add_task(team, task_name) do
    {:ok, _} =
      %TaskEntity{}
      |> TaskEntity.changeset(%{team_id: team.id, name: task_name})
      |> Repo.insert()

    {:ok, find(team.id)}
  end

  @impl Team.Repository
  def delete_task(team, task) do
    {:ok, _entity} = Repo.delete(%TaskEntity{id: task.id})
    {:ok, find(team.id)}
  end

  @impl Team.Repository
  def assign_member_to_task(team, member, task) do
    team_id = team.id
    user_id = member.user.id

    %MemberEntity{id: member_id} =
      Repo.one(from m in MemberEntity, where: m.team_id == ^team_id and m.user_id == ^user_id)

    %AssignmentEntity{team_id: team.id, member_id: member_id, task_id: task.id}
    |> Repo.insert()

    {:ok, find(team.id)}
  end

  @impl Team.Repository
  def unassign_member_from_task(team, member, task) do
    team_id = team.id
    user_id = member.user.id
    task_id = task.id

    Repo.soft_delete_all(
      from to in AssignmentEntity,
        join: m in MemberEntity,
        on: to.member_id == m.id,
        where: to.team_id == ^team_id and m.user_id == ^user_id and to.task_id == ^task_id
    )

    {:ok, find(team.id)}
  end
end
