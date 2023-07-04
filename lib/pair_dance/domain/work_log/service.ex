defmodule PairDance.Domain.WorkLog.Service do
  alias PairDance.Infrastructure.Team.MemberEntity
  alias PairDance.Infrastructure.Team.AssignmentEntity
  alias PairDance.Infrastructure.Team.TaskEntity
  alias PairDance.Infrastructure.User.Entity, as: UserEntity
  alias PairDance.Infrastructure.Repo
  alias PairDance.Domain.Team.Assignment
  import Ecto.Query, warn: false
  import PairDance.Infrastructure.EntityConverters

  def get_task_history(user, team) do
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
    %Assignment{
      member: member,
      task: to_task(task_entity),
      assigned_at: assignment_entity.inserted_at,
      unassigned_at: assignment_entity.deleted_at
    }
  end
end
