defmodule PairDance.Domain.Team.InviteService do
  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Member

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.User.EctoRepository, as: UserRepository

  @type email :: String.t()

  @spec invite(Team.t(), email()) :: Team.t()
  def invite(team, email) do
    user = UserRepository.find_by_email_or_create(email)
    {:ok, updated_team} = TeamRepository.add_member(team, %Member{user: user, role: :admin})

    updated_team
  end
end
