defmodule PairDance.Domain.TeamAccessService do

  alias PairDance.Domain.User
  alias PairDance.Domain.Team

  alias PairDance.Infrastructure.EctoTeamRepository, as: TeamRepository

  @type team_slug :: String.t

  @spec check_access(team_slug(), User.t()) :: boolean
  def check_access(slug, user) do
    case TeamRepository.find_by_slug(slug) do
      nil -> false
      team -> Team.has_member(team, user)
    end
  end

end
