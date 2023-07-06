defmodule PairDance.Domain.WorkLog.Service do
  alias PairDance.Infrastructure.Team.MemberEntity
  alias PairDance.Infrastructure.Team.AssignmentEntity
  alias PairDance.Infrastructure.Team.TaskEntity
  alias PairDance.Infrastructure.User.Entity, as: UserEntity
  alias PairDance.Infrastructure.Repo
  alias PairDance.Domain.Team.Member
  import Ecto.Query, warn: false
  import PairDance.Infrastructure.EntityConverters

  def get_assignments_by_user(user, team) do
    member = Enum.find(team.members, fn m -> m.user.id == user.id end)
    user_id = user.id
    team_id = team.id

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

    Repo.all(query, with_deleted: true) |> Enum.map(fn [a, t] -> convert(a, t, member) end)
  end

  defp convert(assignment_entity, task_entity, member) do
    to_assignment(assignment_entity, member, to_task(task_entity))
  end

  defp convert_for_task(assignment_entity, user_entity, task) do
    member = %Member{
      user: to_user(user_entity),
      role: :admin
    }

    to_assignment(assignment_entity, member, task)
  end

  def get_assignments_by_task(task) do
    task_id = task.id

    query =
      from a in AssignmentEntity,
        join: m in MemberEntity,
        on: m.id == a.member_id,
        join: u in UserEntity,
        on: u.id == m.user_id,
        where: a.task_id == ^task_id,
        select: [a, u]

    Repo.all(query, with_deleted: true)
    |> Enum.map(fn [a, u] -> convert_for_task(a, u, task) end)
  end
end
