defmodule PairDance.Infrastructure.EctoTeamRepository do

  alias PairDance.Domain.TeamRepository
  alias PairDance.Domain.Team

  @behaviour TeamRepository

  @impl TeamRepository
  def create_team(name) do
    %Team{ name: name }
  end
end
