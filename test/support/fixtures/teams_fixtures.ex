defmodule PairDance.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PairDance.Teams` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(name \\ "some name") do
    {:ok, team} = PairDance.Infrastructure.EctoTeamRepository.create(name)
    team
  end

  @doc """
  Generate a member, assumes a valid team id is passed in.
  """
  @spec member_fixture(Team.t(), String.t()) :: TeamMember.t()
  def member_fixture(team, email \\ "bob@me.com") do
    %PairDance.Domain.Team{ members: members } = PairDance.Domain.TeamInviteService.invite(team, email)
    Enum.find(members, fn m -> m.user.email == email end)
  end

  @doc """
  Generate a task.
  """
  @spec task_fixture(Team.t(), String.t()) :: Task.t()
  def task_fixture(team, task_name \\ "logout is broken") do
    {:ok, updated_team} = PairDance.Infrastructure.EctoTeamRepository.add_task(team, task_name)
    Enum.find(updated_team.tasks, fn t -> t.name == task_name end)
  end
end
