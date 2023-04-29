defmodule PairDance.Domain.TeamRepository do

  alias PairDance.Domain.Team

  @type team_id :: integer

  @callback create(String.t()) :: {:ok, Team.t()}

  @callback find(team_id()) :: Team.t() | nil

  @callback find_all() :: list(Team.t())

  @callback delete(team_id()) :: {:ok}
end
