defmodule PairDance.Domain.TeamRepository do

  alias PairDance.Domain.Team
  alias PairDance.Domain.TeamMember

  @type team_id :: integer
  @type slug :: String.t
  @type task_name :: String.t

  @callback create(String.t()) :: {:ok, Team.t()}

  @callback find(team_id()) :: Team.t() | nil

  @callback find_by_slug(slug()) :: Team.t() | nil

  @callback find_all() :: list(Team.t())

  @callback update(team_id(), map()) :: {:ok, Team.t()}

  @callback delete(team_id()) :: {:ok}

  @callback add_member(Team.t(), TeamMember.t()) :: {:ok, Team.t()}

  @callback add_task(Team.t(), task_name()) :: {:ok, Team.t()}
end
