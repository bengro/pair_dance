defmodule PairDance.Infrastructure.Insights.EctoService do
  alias PairDance.Infrastructure.Team.MemberEntity
  alias PairDance.Infrastructure.Team.AssignmentEntity
  alias PairDance.Infrastructure.Team.TaskEntity
  alias PairDance.Infrastructure.User.Entity, as: UserEntity
  alias PairDance.Infrastructure.Repo
  import Ecto.Query, warn: false
  import PairDance.Infrastructure.EntityConverters

  @behaviour PairDance.Domain.Insights.Repo

  def get_assigned_tasks_by_user(user, team) do
    user_id = user.id
    team_id = team.descriptor.id

    query =
      from a in AssignmentEntity,
        join: m in MemberEntity,
        on: m.id == a.member_id,
        join: u in UserEntity,
        on: u.id == m.user_id,
        join: t in TaskEntity,
        on: t.id == a.task_id,
        where: m.user_id == ^user_id and a.team_id == ^team_id,
        select: [a, t]

    assigned_tasks =
      Repo.all(query, with_deleted: true)
      |> Enum.map(fn [a, t] -> to_assigned_task(a, t) end)

    {:ok, assigned_tasks}
  end

  def get_assigned_members_by_task(task) do
    task_id = task.id

    query =
      from a in AssignmentEntity,
        join: m in MemberEntity,
        on: m.id == a.member_id,
        join: u in UserEntity,
        on: u.id == m.user_id,
        where: a.task_id == ^task_id,
        select: [a, m, u]

    assigned_members =
      Repo.all(query, with_deleted: true)
      |> Enum.map(fn [a, m, u] -> to_assigned_member(a, m, u) end)

    {:ok, assigned_members}
  end

  def get_assignments_by_team(team) do
    team_id = team.descriptor.id

    query =
      from a in AssignmentEntity,
        join: m in MemberEntity,
        on: m.id == a.member_id,
        join: u in UserEntity,
        on: u.id == m.user_id,
        join: t in TaskEntity,
        on: t.id == a.task_id,
        where: a.team_id == ^team_id,
        select: [a, t, m, u]

    assignments =
      Repo.all(query, with_deleted: true)
      |> Enum.map(fn [a, t, m, u] ->
        to_assignment(a, to_member(m, u), to_task_descriptor(t))
      end)

    {:ok, assignments}
  end
end
