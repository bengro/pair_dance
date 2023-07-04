defmodule PairDance.Infrastructure.EntityConverters do
  alias PairDance.Domain.Team.Assignment
  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.User
  alias PairDance.Domain.Team.Task

  def to_team(entity) do
    %Team{
      id: entity.id,
      name: entity.name,
      slug: entity.slug,
      members: entity.members |> Enum.map(&to_team_member/1),
      tasks: entity.tasks |> Enum.map(&to_task/1),
      assignments: entity.assignments |> Enum.map(&to_assignment/1)
    }
  end

  def to_team_member(entity) do
    %Member{user: to_user(entity.user), role: :admin}
  end

  def to_task(entity) do
    %Task{id: entity.id, name: entity.name}
  end

  def to_user(entity) do
    %User{id: entity.id, email: entity.email, name: entity.name, avatar: entity.avatar}
  end

  def to_assignment(entity) do
    %Assignment{
      member: to_team_member(entity.member),
      task: to_task(entity.task),
      assigned_at: entity.inserted_at,
      unassigned_at: entity.deleted_at
    }
  end
end
