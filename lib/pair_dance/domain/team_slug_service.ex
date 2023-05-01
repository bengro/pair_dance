defmodule PairDance.Domain.TeamSlugService do

  alias PairDance.Domain.Team

  alias PairDance.Infrastructure.EctoTeamRepository, as: TeamRepository

  @spec slugify(String.t()) :: String.t()
  def slugify(str) do
    str |> String.replace(" ", "-") |> String.downcase()
  end

  @spec set_simple_slug(Team.t()) :: {:ok, Team.t()}
  def set_simple_slug(team) do
    TeamRepository.update(team.id, %{ slug: slugify(team.name) })
  end

end
