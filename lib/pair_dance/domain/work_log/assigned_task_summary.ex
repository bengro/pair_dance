defmodule PairDance.Domain.WorkLog.AssignedTaskSummary do
  alias __MODULE__

  alias PairDance.Domain.Team.TimeRange

  @enforce_keys [:task, :time_ranges]
  defstruct [:task, :time_ranges]

  @type t() :: %__MODULE__{
          task: Task.Descriptor.t(),
          time_ranges: list(TimeRange.t())
        }

  @spec build(list(AssignedTask.t())) :: list(AssignedTaskSummary.t())
  def build(assignments) do
    Enum.group_by(assignments, fn a -> a.task.id end, fn a -> a end)
    |> Enum.map(fn {_, as} -> build_for_one_task(as) end)
    |> Enum.sort(&compare/2)
    |> Enum.reverse()
  end

  defp build_for_one_task(assignments) do
    task = Enum.at(assignments, 0).task

    time_ranges =
      Enum.map(assignments, fn a -> a.time_range end)
      |> Enum.sort(&TimeRange.compare/2)

    %AssignedTaskSummary{task: task, time_ranges: time_ranges}
  end

  @doc """
  Returns true if the first argument precedes or is in the same place as the second one.
  Compatible with Enum.sort/2
  """
  @spec compare(AssignedTaskSummary.t(), AssignedTaskSummary.t()) :: boolean
  def compare(s1, s2) do
    max1 = Enum.max(s1.time_ranges, &TimeRange.compare/2)
    max2 = Enum.max(s2.time_ranges, &TimeRange.compare/2)
    TimeRange.compare(max1, max2)
  end
end
