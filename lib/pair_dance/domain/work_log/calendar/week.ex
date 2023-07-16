defmodule PairDance.Domain.WorkLog.Calendar.Week do
  alias __MODULE__

  @enforce_keys [:start_date, :num_days, :task_ids]
  defstruct [:start_date, :num_days, :task_ids]

  @type t() :: %__MODULE__{
          start_date: Date.t(),
          num_days: number,
          task_ids: list(list(integer()))
        }

  def build(end_date, assignments) do
    num_days = Date.day_of_week(end_date)
    start_date = Date.add(end_date, 1 - num_days)

    %Week{
      start_date: start_date,
      num_days: num_days,
      task_ids: build_task_ids(start_date, num_days, assignments)
    }
  end

  defp build_task_ids(start_date, num_days, assignments) do
    tasks =
      Enum.map(assignments, fn assignment ->
        start_index = Date.diff(assignment.time_range.start, start_date)

        end_index =
          case assignment.time_range.end do
            nil -> 7
            end_time -> Date.diff(end_time, start_date)
          end

        {assignment.task.id, start_index, end_index}
      end)
      |> Enum.filter(fn {_, start_index, end_index} -> start_index < 7 && end_index >= 0 end)

    Enum.map(0..(num_days - 1), fn day_index ->
      Enum.filter(tasks, fn {_, start_index, end_index} ->
        day_index >= start_index && day_index <= end_index
      end)
      |> Enum.map(fn {id, _, _} -> id end)
    end)
  end
end
