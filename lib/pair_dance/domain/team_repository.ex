defmodule PairDance.Domain.TeamRepository do

  alias PairDance.Domain.Team


  @callback create(String.t()) :: Team.t()

  @callback find(integer()) :: Team.t()
end
