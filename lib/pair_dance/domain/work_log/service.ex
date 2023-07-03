defmodule PairDance.Domain.WorkLog.Service do
  alias PairDance.Infrastructure.Team.MemberEntity
  alias PairDance.Infrastructure.Team.AssignmentEntity
  alias PairDance.Infrastructure.Team.TaskEntity
  alias PairDance.Infrastructure.Repo
  import Ecto.Query, warn: false
  import PairDance.Infrastructure.EntityConverters

  def get_task_history(user, team) do
    user_id = user.id

    Repo.all(
      from m in MemberEntity,
        join: a in AssignmentEntity,
        on: m.id == a.member_id,
        join: t in TaskEntity,
        on: t.id == a.task_id,
        where: m.user_id == ^user_id,
        preload: [a: :member]
    )
    |> Enum.map(fn row -> IO.inspect(row) end)
  end
end
