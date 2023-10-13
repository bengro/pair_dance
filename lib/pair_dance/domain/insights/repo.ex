defmodule PairDance.Domain.Insights.Repo do
  alias PairDance.Domain.Team
  alias PairDance.Domain.User
  alias PairDance.Domain.Team.AssignedTask
  alias PairDance.Domain.Team.AssignedMember

  @callback get_assigned_tasks_by_user(User.t(), Team.t()) :: {:ok, list(AssignedTask.t())}

  @callback get_assigned_members_by_task(Task.Descriptor.t()) :: {:ok, list(AssignedMember.t())}

  @callback get_assignments_by_team(Team.t()) :: {:ok, list(Team.Assignment.t())}
end
