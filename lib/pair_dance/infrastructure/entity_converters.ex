defmodule PairDance.Infrastructure.EntityConverters do

  alias PairDance.Domain.Team.Assignment
  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.User
  alias PairDance.Domain.Team.Task

  alias PairDance.Infrastructure.TeamEntity
  alias PairDance.Infrastructure.Team.MemberEntity
  alias PairDance.Infrastructure.Team.AssignmentEntity
  alias PairDance.Infrastructure.UserEntity
  alias PairDance.Teams.Task, as: TaskEntity

  @spec to_team(TeamEntity) :: Team.t()
  def to_team(entity) do
    %Team{
      id: entity.id,
      name: entity.name,
      slug: entity.slug,
      members: entity.members |> Enum.map(&to_team_member/1),
      tasks: entity.tasks |> Enum.map(&to_task/1),
      assignments: entity.assignments |> Enum.map(&to_assignment/1),
    }
  end

  @spec to_team_member(MemberEntity) :: Member.t()
  def to_team_member(entity) do
    %Member{ user: to_user(entity.user), role: :admin }
  end

  @spec to_task(TaskEntity) :: Task.t()
  def to_task(entity) do
    %Task{ id: entity.id, name: entity.name }
  end

  @spec to_user(UserEntity) :: User.t()
  def to_user(entity) do
    %User{ id: entity.id, email: entity.email, name: entity.name, avatar: entity.avatar }
  end

  @spec to_assignment(AssignmentEntity) :: Assignment.t()
  def to_assignment(entity) do
    %Assignment{ member: to_team_member(entity.member), task: to_task(entity.task)}
  end

end
