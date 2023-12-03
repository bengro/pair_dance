defmodule PairDance.Domain.Insights.Repo do
  alias PairDance.Domain.Team
  alias PairDance.Domain.User
  alias PairDance.Domain.Team.AssignedTask

  @callback get_assigned_tasks_by_user(User.t(), Team.t()) :: {:ok, list(AssignedTask.t())}

  @callback get_assignments_by_team(Team.t()) :: {:ok, list(Team.Assignment.t())}
end
