defmodule PairDance.Infrastructure.EntityConverters do
  alias PairDance.Domain.Team.Assignment
  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.User
  alias PairDance.Domain.Team.Task
  alias PairDance.Domain.Team.TimeRange

  def to_team_descriptor(entity) do
    %Team.Descriptor{
      id: entity.id,
      name: entity.name,
      slug: entity.slug
    }
  end

  def to_member(entity) do
    %Member{id: entity.id, user: to_user(entity.user), role: :admin, available: entity.available}
  end

  def to_task_descriptor(entity) do
    %Task.Descriptor{id: entity.id, name: entity.name}
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
