defmodule PairDance.Domain.Team.SlugService do
  alias PairDance.Domain.Team

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  @type slug :: String.t()

  @spec slugify(String.t()) :: String.t()
  def slugify(str) do
    Regex.scan(~r/[a-z0-9]+/, String.downcase(str))
    |> Enum.map(fn [x] -> x end)
    |> Enum.join("-")
  end

  @spec set_slug(Team.t(), slug()) :: {:ok, Team.t()} | {:conflict, slug()}
  def set_slug(team, slug) do
    slug = slugify(slug)

    case TeamRepository.update(team.descriptor.id, %{slug: slug}) do
      {:ok, team} -> {:ok, team}
      {:error, {:conflict, _}} -> {:conflict, slug}
    end
  end
end
