defmodule PairDance.Domain.WorkLog.AssignedTaskSummary do
  alias __MODULE__

  alias PairDance.Domain.Team.TimeRange

  @enforce_keys [:task, :time_range, :time_ranges]
  defstruct [:task, :time_range, :time_ranges]

  @type t() :: %__MODULE__{
          task: Task.Descriptor.t(),
          time_ranges: list(TimeRange.t())
        }

  @spec build(list(AssignedTask.t())) :: list(AssignedTaskSummary.t())
  def build(assignments) do
    Enum.group_by(assignments, fn a -> a.task.id end, fn a -> a end)
    |> Enum.map(fn {_, as} -> build_for_one_task(as) end)
    |> Enum.sort(AssignedTaskSummary)
    |> Enum.reverse()
  end

  defp build_for_one_task(assignments) do
    task = Enum.at(assignments, 0).task

    time_ranges =
      Enum.map(assignments, fn a -> a.time_range end)
      |> Enum.sort(TimeRange)

    time_range = TimeRange.merge(time_ranges)

    %AssignedTaskSummary{task: task, time_range: time_range, time_ranges: time_ranges}
  end

  @spec compare(AssignedTaskSummary.t(), AssignedTaskSummary.t()) :: :lt | :eq | :gt
  def compare(s1, s2) do
    TimeRange.compare(s1.time_range, s2.time_range)
  end
end
