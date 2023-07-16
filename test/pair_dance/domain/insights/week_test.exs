defmodule PairDance.Domain.Insights.WeekTest do
  use PairDance.DataCase

  alias PairDance.Domain.Insights.Week
  alias PairDance.Domain.Team.Model.AssignedTask
  alias PairDance.Domain.Team.AssignedTask
  alias PairDance.Domain.Team.Task
  alias PairDance.Domain.Team.TimeRange

  test "returns a list of weeks" do
    assert [%Week{}] = Week.build([], num_weeks: 1)
  end

  test "returns requested number of weeks" do
    weeks = Week.build([], num_weeks: 4)

    assert length(weeks) == 4
  end

  test "weeks are ordered by start dates" do
    [week1, week2, week3] = Week.build([], num_weeks: 3, end_date: ~D[2023-07-11])

    assert week1.start_date == ~D[2023-06-26]
    assert week2.start_date == ~D[2023-07-03]
    assert week3.start_date == ~D[2023-07-10]
  end

  test "last week is shorter according to the end date" do
    [week1, week2] = Week.build([], num_weeks: 2, end_date: ~D[2023-07-12])

    assert week1.num_days == 7
    assert week2.num_days == 3
  end

  describe "task ids" do
    defp setup_data(_) do
      %{
        long_task: %AssignedTask{
          task: %Task.Descriptor{id: 1, name: ""},
          time_range: %TimeRange{
            start: ~U[2023-07-01 00:01:00.00Z],
            end: ~U[2023-07-23 00:01:00.00Z]
          }
        },
        short_task: %AssignedTask{
          task: %Task.Descriptor{id: 2, name: ""},
          time_range: %TimeRange{
            start: ~U[2023-07-11 00:01:00.00Z],
            end: ~U[2023-07-13 00:01:00.00Z]
          }
        }
      }
    end

    setup [:setup_data]

    test "when assignment longer than week", %{long_task: task} do
      [%Week{task_ids: task_ids}] = Week.build([task], num_weeks: 1, end_date: ~D[2023-07-15])

      assert [[1], [1], [1], [1], [1], [1]] = task_ids
    end

    test "when assignment smaller than week", %{short_task: task} do
      [%Week{task_ids: task_ids}] = Week.build([task], num_weeks: 1, end_date: ~D[2023-07-15])

      assert [[], [2], [2], [2], [], []] = task_ids
    end

    test "when multiple tasks", %{short_task: short_task, long_task: long_task} do
      [%Week{task_ids: task_ids}] =
        Week.build([short_task, long_task], num_weeks: 1, end_date: ~D[2023-07-15])

      assert [[1], [_, _], [_, _], [_, _], [1], [1]] = task_ids
    end
  end
end
