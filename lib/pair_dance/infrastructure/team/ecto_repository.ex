defmodule PairDance.Infrastructure.Team.EctoRepository do
  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Task

  alias PairDance.Infrastructure.TeamEntity
  alias PairDance.Infrastructure.User
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
    tasks_query = from t in TaskEntity, where: t.team_id == ^id

    tasks = Repo.all(tasks_query) |> Enum.map(&to_task_descriptor/1)

    members_query = from m in MemberEntity, where: m.team_id == ^id, preload: :user
    members = Repo.all(members_query) |> Enum.map(&to_member/1)

    assignments_query =
      from a in AssignmentEntity,
        where: a.team_id == ^id,
        preload: [:task, :member, [member: :user]]

    assignments =
      Repo.all(assignments_query)
      |> Enum.map(fn a -> to_assignment(a, to_member(a.member), to_task_descriptor(a.task)) end)

    query =
      from t in TeamEntity,
        where: t.id == ^id

    entity = Repo.one(query)

    if entity == nil do
      nil
    else
      %Team{
        descriptor: to_team_descriptor(entity),
        members: members,
        tasks: tasks,
        assignments: assignments
      }
    end
  end

  @impl Team.Repository
  def find_by_member(member_id) do
    Repo.all(
      from t in TeamEntity,
        join: m in MemberEntity,
        on: t.id == m.team_id,
        where: m.user_id == ^member_id
    )
    |> Enum.map(&to_team_descriptor/1)
  end

  @impl Team.Repository
  def find_by_slug?(slug) do
    id = Repo.one(from t in TeamEntity, where: t.slug == ^slug, select: t.id)

    if id == nil do
      nil
    else
      find(id)
    end
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
      |> MemberEntity.changeset(%{user_id: member.user.id, team_id: team.descriptor.id})
      |> Repo.insert()

    {:ok, find(team.descriptor.id)}
  end

  @impl Team.Repository
  def delete_member(team, member) do
    Repo.delete(%MemberEntity{id: member.id})

    {:ok, find(team.descriptor.id)}
  end

  @impl Team.Repository
  def add_task(team, task_name) do
    {:ok, _} =
      %TaskEntity{}
      |> TaskEntity.changeset(%{team_id: team.descriptor.id, name: task_name})
      |> Repo.insert()

    {:ok, find(team.descriptor.id)}
  end

  @impl Team.Repository
  def get_tasks(team) do
    id = team.descriptor.id

    tasks_query =
      from t in TaskEntity,
        left_join: a in AssignmentEntity,
        on: a.task_id == t.id,
        left_join: m in MemberEntity,
        on: a.member_id == m.id,
        left_join: u in User.Entity,
        on: m.user_id == u.id,
        where: t.team_id == ^id,
        select: [a, t, m, u]

    tasks =
      Repo.all(tasks_query)
      |> Enum.map(fn [a, t, m, u] ->
        {to_task_descriptor(t),
         case m do
           nil -> nil
           _ -> to_assigned_member(a, m, u)
         end}
      end)
      |> Enum.group_by(fn {t, _} -> t.id end)
      |> Enum.map(fn {_, grouped_assignments} ->
        {descriptor, _} = Enum.at(grouped_assignments, 0)

        assigned_members =
          Enum.map(grouped_assignments, fn {_, member} -> member end)
          |> Enum.filter(fn member -> member != nil end)

        %Task{descriptor: descriptor, assigned_members: assigned_members}
      end)

    {:ok, tasks}
  end

  @impl Team.Repository
  def delete_task(team, task) do
    team_id = team.descriptor.id
    task_id = task.id

    Repo.soft_delete_all(
      from to in AssignmentEntity,
        join: m in MemberEntity,
        on: to.member_id == m.id,
        where: to.team_id == ^team_id and to.task_id == ^task_id
    )

    {:ok, _entity} = Repo.soft_delete(%TaskEntity{id: task.id})
    {:ok, find(team.descriptor.id)}
  end

  @impl Team.Repository
  def assign_member_to_task(team, member, task) do
    team_id = team.descriptor.id
    user_id = member.user.id

    %MemberEntity{id: member_id} =
      Repo.one(from m in MemberEntity, where: m.team_id == ^team_id and m.user_id == ^user_id)

    %AssignmentEntity{team_id: team.descriptor.id, member_id: member_id, task_id: task.id}
    |> Repo.insert()

    {:ok, find(team.descriptor.id)}
  end

  @impl Team.Repository
  def unassign_member_from_task(team, member, task) do
    team_id = team.descriptor.id
    user_id = member.user.id
    task_id = task.id

    Repo.soft_delete_all(
      from to in AssignmentEntity,
        join: m in MemberEntity,
        on: to.member_id == m.id,
        where: to.team_id == ^team_id and m.user_id == ^user_id and to.task_id == ^task_id
    )

    {:ok, find(team.descriptor.id)}
  end

  @impl Team.Repository
  def mark_member_unavailable(team, member) do
    %MemberEntity{id: member.id}
    |> MemberEntity.changeset(%{
      user_id: member.user.id,
      team_id: team.descriptor.id,
      available: false
    })
    |> Repo.update()

    {:ok, find(team.descriptor.id)}
  end

  @impl Team.Repository
  def mark_member_available(team, member) do
    %MemberEntity{id: member.id}
    |> MemberEntity.changeset(%{
      user_id: member.user.id,
      team_id: team.descriptor.id,
      available: true
    })
    |> Repo.update()

    {:ok, find(team.descriptor.id)}
  end
end
