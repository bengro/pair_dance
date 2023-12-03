defmodule PairDance.Domain.Insights.HeatmapTest do
  use PairDance.DataCase

  alias PairDance.Domain.Insights.Heatmap
  alias PairDance.Domain.Team.TimeRange
  alias PairDance.Domain.Team.Assignment
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.Team.Task
  alias PairDance.Domain.User

  test "computes member heatmap for single assignment" do
    task_id = :rand.uniform(100)

    heatmap =
      Heatmap.calculate_heatmap([
        create_assignment(%{
          task_name: "A wonderful task",
          task_id: task_id,
          user_id: 1,
          time_range: %TimeRange{
            start: ~U[2023-06-26 21:20:07.123Z],
            end: ~U[2023-06-27 21:20:07.123Z]
          }
        })
      ])

    assert length(heatmap) == 1

    [interaction] = heatmap
    assert interaction.task.descriptor.name == "A wonderful task"
    assert interaction.member_pairings == []
    assert length(interaction.members) == 1
  end

  test "computes member heatmap for two or more assignments" do
    task_id = :rand.uniform(100)

    heatmap =
      Heatmap.calculate_heatmap([
        create_assignment(%{
          task_name: "A wonderful task",
          task_id: task_id,
          user_id: 1,
          time_range: %TimeRange{
            start: ~U[2023-06-26 21:20:07.123Z],
            end: ~U[2023-06-27 21:20:07.123Z]
          }
        }),
        create_assignment(%{
          task_name: "A wonderful task",
          task_id: task_id,
          user_id: 2,
          time_range: %TimeRange{start: ~U[2023-06-26 21:20:07.123Z], end: nil}
        })
      ])

    assert length(heatmap) == 1

    [interaction] = heatmap
    assert interaction.task.descriptor.name == "A wonderful task"
    assert interaction.member_pairings == [{2, 1}]
    assert length(interaction.members) == 2
  end

  test "computes member heatmap for two assignments not overlapping" do
    task_id = :rand.uniform(100)

    heatmap =
      Heatmap.calculate_heatmap([
        create_assignment(%{
          task_name: "A wonderful task",
          task_id: task_id,
          user_id: 1,
          time_range: %TimeRange{
            start: ~U[2023-06-26 21:20:07.123Z],
            end: ~U[2023-06-27 21:20:07.123Z]
          }
        }),
        create_assignment(%{
          task_name: "A wonderful task",
          task_id: task_id,
          user_id: 2,
          time_range: %TimeRange{start: ~U[2023-06-28 21:20:07.123Z], end: nil}
        })
      ])

    assert length(heatmap) == 1

    [interaction] = heatmap
    assert interaction.task.descriptor.name == "A wonderful task"
    assert interaction.member_pairings == []
    assert length(interaction.members) == 2
  end

  def create_assignment(%{
        task_name: task_name,
        task_id: task_id,
        user_id: user_id,
        time_range: time_range
      }) do
    %Assignment{
      member: %Member{
        id: user_id,
        user: %User{id: user_id, email: "#{:rand.uniform(100)}@pair.dance"},
        role: :admin
      },
      task: %Task{
        descriptor: %Task.Descriptor{id: task_id, name: task_name},
        assigned_members: []
      },
      time_range: time_range
    }
  end
end
