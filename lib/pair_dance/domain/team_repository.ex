defmodule PairDance.Domain.TeamRepository do

  alias PairDance.Domain.Team


  @callback create_team(String.name) :: Team.team

end
