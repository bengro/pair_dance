defmodule PairDance.Domain.WorkLog.Service do
  alias PairDance.Infrastructure.Team.MemberEntity
  alias PairDance.Infrastructure.Team.AssignmentEntity
  alias PairDance.Infrastructure.Team.TaskEntity
  alias PairDance.Infrastructure.User.Entity, as: UserEntity
  alias PairDance.Infrastructure.Repo
  import Ecto.Query, warn: false
  import PairDance.Infrastructure.EntityConverters

  def get_task_history(user, team) do
    user_id = user.id
    team_id = team.id
    query = from a in AssignmentEntity,
        join: m in MemberEntity,
        on: m.id == a.member_id,
        join: u in UserEntity,
        on: u.id == m.user_id,
        join: t in TaskEntity,
        on: t.id == a.task_id,
        where: m.user_id == ^user_id and a.team_id == ^team_id,
        preload: [member: {m, [user: u]}, task: t]

    Repo.all(query, with_deleted: true) |> Enum.map(&to_assignment/1)
  end
end
