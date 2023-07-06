defmodule PairDance.Infrastructure.EntityConverters do
  alias PairDance.Domain.Team.Assignment
  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.User
  alias PairDance.Domain.Team.Task
  alias PairDance.Domain.Team.TimeRange

  def to_team(entity) do
    %Team{
      id: entity.id,
      name: entity.name,
      slug: entity.slug,
      members: entity.members |> Enum.map(&to_member/1),
      tasks: entity.tasks |> Enum.map(&to_task/1),
      assignments:
        entity.assignments
        |> Enum.map(fn a -> to_assignment(a, to_member(a.member), to_task(a.task)) end)
    }
  end

  def to_member(entity) do
    %Member{id: entity.id, user: to_user(entity.user), role: :admin, available: entity.available}
  end

  def to_task(entity) do
    %Task{id: entity.id, name: entity.name}
  end

  def to_user(entity) do
    %User{id: entity.id, email: entity.email, name: entity.name, avatar: entity.avatar}
  end

  def to_assignment(entity, member, task) do
    %Assignment{
      member: member,
      task: task,
      time_range: %TimeRange{start: entity.inserted_at, end: entity.deleted_at}
    }
  end
end
