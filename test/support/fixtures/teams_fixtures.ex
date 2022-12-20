defmodule PairDance.TeamsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `PairDance.Teams` context.
  """

  @doc """
  Generate a team.
  """
  def team_fixture(attrs \\ %{}) do
    {:ok, team} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> PairDance.Teams.create_team()

    team
  end

  @doc """
  Generate a member.
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
