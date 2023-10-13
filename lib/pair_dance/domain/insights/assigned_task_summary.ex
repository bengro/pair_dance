defmodule PairDance.Domain.Insights.AssignedTaskSummary do
  alias __MODULE__

  alias PairDance.Domain.Team.TimeRange
  alias PairDance.Domain.Team.Member

  @enforce_keys [:task, :member, :time_range, :time_ranges]
  defstruct [:task, :member, :time_range, :time_ranges]

  @type t() :: %__MODULE__{
          task: Task.Descriptor.t(),
          member: Member.t(),
          time_ranges: list(TimeRange.t())
        }

  @spec build(Member.t(), list(AssignedTask.t())) :: list(AssignedTaskSummary.t())
  def build(member, all_assignments) do
    Enum.group_by(all_assignments, fn a -> a.task.id end, fn a -> a end)
    |> Enum.map(fn {_, task_assignments} -> build_for_one_task(task_assignments, member) end)
    |> Enum.sort(AssignedTaskSummary)
    |> Enum.reverse()
  end

  defp build_for_one_task(assignments, member) do
    task = Enum.at(assignments, 0).task

    time_ranges =
      Enum.map(assignments, fn a -> a.time_range end)
      |> Enum.sort(TimeRange)

    time_range = TimeRange.merge(time_ranges)

    %AssignedTaskSummary{
      task: task,
      time_range: time_range,
      time_ranges: time_ranges,
      member: member
    }
  end

  @spec compare(AssignedTaskSummary.t(), AssignedTaskSummary.t()) :: :lt | :eq | :gt
  def compare(s1, s2) do
    TimeRange.compare(s1.time_range, s2.time_range)
  end
end
