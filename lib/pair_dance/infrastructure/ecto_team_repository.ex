defmodule PairDance.Infrastructure.EctoTeamRepository do

  alias PairDance.Domain.TeamRepository

  @behaviour TeamRepository

  @impl TeamRepository
  def create_team(name) do
    %{ name: name }
  end
end
