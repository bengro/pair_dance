defmodule PairDance.Domain.TeamRepository do

  alias PairDance.Domain.Team


  @callback create(String.t()) :: {:ok, Team.t()}

  @callback find(integer()) :: Team.t() | nil

end
