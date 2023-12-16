defmodule PairDance.Domain.Insights.ReportTest do
  use PairDance.DataCase

  alias PairDance.Domain.Insights.Report
  alias PairDance.Domain.Insights.Report.Pairing
  alias PairDance.Domain.Team.TimeRange
  alias PairDance.Domain.Team.Assignment
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.Team.Task
  alias PairDance.Domain.User

  test "generate report with one activity and no pairing" do
    task_id = :rand.uniform(100)

    report =
      Report.generate_report([
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

    [activity] = report.task_activities
    assert activity.task.name == "A wonderful task"
    assert activity.pairings == []
    assert length(activity.involved_members) == 1
  end

  test "generate report for one activity with multiple pairings" do
    task_id = :rand.uniform(100)

    report =
      Report.generate_report([
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

    assert length(report.task_activities) == 1

    [activity] = report.task_activities
    assert activity.task.name == "A wonderful task"
    assert [%Pairing{pair1: _, pair2: _, duration_days: 1}] = activity.pairings
    assert length(activity.involved_members) == 2
  end

  test "generate report for one activity which people worked on at different times" do
    task_id = :rand.uniform(100)

    report =
      Report.generate_report([
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

    assert length(report.task_activities) == 1

    [activity] = report.task_activities
    assert activity.task.name == "A wonderful task"
    assert activity.pairings == []
    assert length(activity.involved_members) == 2
  end

  test "generate report which shows who has paired with who how many times" do
    task_id = :rand.uniform(100)

    report =
      Report.generate_report([
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
        }),
        create_assignment(%{
          task_name: "A wonderful task",
          task_id: task_id,
          user_id: 3,
          time_range: %TimeRange{start: ~U[2023-06-27 21:20:08.123Z], end: nil}
        })
      ])

    user_activities = report.user_activities

    assert user_activities["1"] == [2]
    assert user_activities["2"] == [1, 3]
    assert user_activities["3"] == [2]
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
      task: %Task.Descriptor{id: task_id, name: task_name},
      time_range: time_range
    }
  end
end
