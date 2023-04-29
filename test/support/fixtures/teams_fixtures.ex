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
  def member_fixture(attrs \\ %{}) do
    {:ok, member} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> PairDance.Teams.create_member()

    member
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
