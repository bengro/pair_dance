defmodule PairDance.Domain.TeamInviteService do

  alias PairDance.Domain.Team
  alias PairDance.Domain.TeamMember

  alias PairDance.Infrastructure.EctoTeamRepository, as: TeamRepository
  alias PairDance.Infrastructure.EctoUserRepository, as: UserRepository

  @type email :: String.t

  @spec invite(Team.t(), email()) :: Team.t()
  def invite(team, email) do
    user = UserRepository.find_by_email_or_create(email)
    {:ok, updated_team } = TeamRepository.add_member(team, %TeamMember{ user: user, role: :admin })

    updated_team
  end

end
