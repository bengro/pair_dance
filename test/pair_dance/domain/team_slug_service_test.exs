defmodule PairDance.Domain.TeamSlugServiceTest do
  use PairDance.DataCase

  alias PairDance.Infrastructure.EctoTeamRepository, as: TeamRepository
  alias PairDance.Domain.TeamSlugService
  alias PairDance.Domain.Team

  describe "set simple team url slug" do

    test "simple team name" do
      {:ok, team } = TeamRepository.create("team X")

      {:ok, team } = TeamSlugService.set_simple_slug(team)

      assert %Team{ slug: slug } = team
      assert slug == "team-x"
      assert TeamRepository.find(team.id) == team
    end


  end

  describe "normalise slug" do

    test "characters are lowercased" do
      assert TeamSlugService.slugify("ABC") == "abc"
    end

    test "white spaces replaced by dashes" do
      assert TeamSlugService.slugify("pair dance") == "pair-dance"
    end

  end

end
