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
  def task_fixture(attrs \\ %{}) do
    {:ok, task} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> PairDance.Teams.create_task()

    task
  end
end
