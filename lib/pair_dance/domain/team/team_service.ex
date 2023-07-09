defmodule PairDance.Domain.Team.TeamService do
  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.User

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Domain.Team.SlugService

  @type team_name :: String.t()

  @spec new_team(team_name(), User.t()) :: {:ok, Team.t()}
  def new_team(name, owner) do
    {:ok, team} = TeamRepository.create(name)
    team |> try_set_simple_slug |> add_member(owner)
  end

  @spec try_set_simple_slug(Team.t()) :: Team.t()
  defp try_set_simple_slug(team) do
    case SlugService.set_slug(team, team.descriptor.name) do
      {:ok, updated_team} -> updated_team
      {:conflict, _} -> team
    end
  end

  @spec add_member(Team.t(), User.t()) :: {:ok, Team.t()}
  defp add_member(team, owner) do
    TeamRepository.add_member(team, %Member{user: owner, role: :admin})
  end
end
