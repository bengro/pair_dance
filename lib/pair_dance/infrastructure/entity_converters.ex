defmodule PairDance.Infrastructure.EntityConverters do

  alias PairDance.Domain.Team
  alias PairDance.Domain.TeamMember
  alias PairDance.Domain.User

  alias PairDance.Infrastructure.TeamEntity
  alias PairDance.Infrastructure.TeamMemberEntity
  alias PairDance.Infrastructure.UserEntity

  @spec to_team(TeamEntity) :: Team.t()
  def to_team(entity) do
    %Team{ id: entity.id, name: entity.name, slug: entity.slug, members: entity.members |> Enum.map(&to_team_member/1) }
  end

  @spec to_team_member(TeamMemberEntity) :: TeamMember.t()
  def to_team_member(entity) do
    %TeamMember{ user: to_user(entity.user), role: :admin }
  end

  @spec to_user(UserEntity) :: User.t()
  def to_user(entity) do
    %User{ id: entity.id, email: entity.email }
  end

end
