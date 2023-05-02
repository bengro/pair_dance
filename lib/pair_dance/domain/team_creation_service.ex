defmodule PairDance.Domain.TeamCreationService do

  alias PairDance.Domain.Team

  alias PairDance.Infrastructure.EctoTeamRepository, as: TeamRepository
  alias PairDance.Domain.TeamSlugService

  @spec new_team(String.t()) :: {:ok, Team.t()}
  def new_team(name) do
    {:ok, team} = TeamRepository.create(name)
    case TeamSlugService.set_slug(team, team.name) do
      {:ok, team} -> {:ok, team}
      {:conflict, _} -> {:ok, team}
    end
  end

end
