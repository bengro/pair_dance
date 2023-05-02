defmodule PairDance.Domain.TeamSlugServiceTest do
  use PairDance.DataCase

  alias PairDance.Infrastructure.EctoTeamRepository, as: TeamRepository
  alias PairDance.Domain.TeamSlugService

  describe "set slug" do

    test "requested value is normalised" do
      {:ok, team} = TeamRepository.create("my team")

      {:ok, team} = TeamSlugService.set_slug(team, "my new slug")

      assert team.slug == "my-new-slug"
      assert TeamRepository.find(team.id) == team
    end

    test "nothing changes in case of conflict" do
      case TeamRepository.create("infra") do
        {:ok, anotherTeam} -> TeamSlugService.set_slug(anotherTeam, "infra")
      end
      {:ok, team} = TeamRepository.create("infra")

      {:conflict, "infra"} = TeamSlugService.set_slug(team, "infra")

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

    test "sequences of non-alphanumeric characters are replaced by dashes" do
      assert TeamSlugService.slugify("cats & dogs") == "cats-dogs"
    end

    test "strings without any alphanumeric characters result in an empty slug" do
      assert TeamSlugService.slugify("!#$/") == ""
    end

  end

end
