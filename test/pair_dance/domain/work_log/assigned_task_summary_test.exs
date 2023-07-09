defmodule PairDance.Domain.WorkLog.AssignedTaskSummaryTest do
  use PairDance.DataCase

  alias PairDance.Domain.Team.Task
  alias PairDance.Domain.Team.TimeRange
  alias PairDance.Domain.Team.AssignedTask
  alias PairDance.Domain.WorkLog.AssignedTaskSummary

  test "lists every task" do
    task1 = a_task(1)
    task2 = a_task(2)

    summary =
      AssignedTaskSummary.build([
        an_assigned_task(task1),
        an_assigned_task(task2),
        an_assigned_task(task1)
      ])

    assert length(summary) == 2
  end

  test "includes task descriptors" do
    [%AssignedTaskSummary{task: task}] =
      AssignedTaskSummary.build([an_assigned_task(a_task(1, "my task"))])

    assert task.name == "my task"
  end

  test "includes time ranges ordered chronologically" do
    task = a_task()
    tr1 = a_time_range(~U[2020-01-01 00:00:00.00Z], ~U[2020-01-01 23:59:59.00Z])
    tr2 = a_time_range(~U[2020-01-02 00:00:00.00Z], ~U[2020-01-02 23:59:59.00Z])
    tr3 = a_time_range(~U[2020-01-03 00:00:00.00Z], nil)

    unordered_assigned_tasks = [
      an_assigned_task(task, tr2),
      an_assigned_task(task, tr3),
      an_assigned_task(task, tr1)
    ]

    [%AssignedTaskSummary{time_ranges: time_ranges}] =
      AssignedTaskSummary.build(unordered_assigned_tasks)

    assert time_ranges == [tr1, tr2, tr3]
  end

  test "summarises individual assignments with a single time range" do
    task = a_task()
    tr1 = a_time_range(~U[2020-01-01 00:00:00.00Z], ~U[2020-01-01 23:59:59.00Z])
    tr2 = a_time_range(~U[2020-01-02 00:00:00.00Z], ~U[2020-01-02 23:59:59.00Z])

    unordered_assigned_tasks = [
      an_assigned_task(task, tr1),
      an_assigned_task(task, tr2)
    ]

    [%AssignedTaskSummary{time_range: time_range}] =
      AssignedTaskSummary.build(unordered_assigned_tasks)

    assert time_range.start == ~U[2020-01-01 00:00:00.00Z]
    assert time_range.end == ~U[2020-01-02 23:59:59.00Z]
  end

  test "shows most recent tasks first" do
    task1 = a_task(1, "first")
    task2 = a_task(2, "second")
    task3 = a_task(3, "third")

    tr1 = a_time_range(~U[2020-01-01 00:00:00.00Z], ~U[2020-01-01 23:59:59.00Z])
    tr2 = a_time_range(~U[2020-01-02 00:00:00.00Z], ~U[2020-01-02 23:59:59.00Z])
    tr3 = a_time_range(~U[2020-01-03 00:00:00.00Z], nil)

    unordered_assigned_tasks = [
      an_assigned_task(task2, tr2),
      an_assigned_task(task3, tr3),
      an_assigned_task(task1, tr1)
    ]

    task_names =
      AssignedTaskSummary.build(unordered_assigned_tasks) |> Enum.map(fn s -> s.task.name end)

    assert task_names == ["third", "second", "first"]
  end

  def a_task(id \\ Enum.random(1..1000), name \\ "the task") do
    %Task.Descriptor{
      id: id,
      name: name
    }
  end

  def a_time_range(start_time \\ DateTime.utc_now(), end_time \\ DateTime.utc_now()) do
    %TimeRange{
      start: start_time,
      end: end_time
    }
  end

  def an_assigned_task(task \\ a_task(), time_range \\ a_time_range()) do
    %AssignedTask{
      task: task,
      time_range: time_range
    }
  end
end
