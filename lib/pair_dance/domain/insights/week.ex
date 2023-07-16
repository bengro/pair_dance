defmodule PairDance.Domain.Insights.Week do
  alias __MODULE__
  alias PairDance.Domain.Team.AssignedTask

  @enforce_keys [:start_date, :num_days, :task_ids]
  defstruct [:start_date, :num_days, :task_ids]

  @type t() :: %__MODULE__{
          start_date: Date.t(),
          num_days: number,
          task_ids: list(list(integer()))
        }

  @spec build(list(AssignedTask.t())) :: list(Week.t())
  def build(assignments, options \\ []) do
    %{num_weeks: num_weeks, end_date: end_date} =
      Enum.into(options, %{num_weeks: 9, end_date: Date.utc_today()})

    {weeks, _} =
      Enum.map_reduce(1..num_weeks, end_date, fn _, last_date ->
        week = build_week(last_date, assignments)
        {week, Date.add(week.start_date, -1)}
      end)

    Enum.reverse(weeks)
  end

  defp build_week(end_date, assignments) do
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
        end_index = Date.diff(assignment.time_range.end, start_date)
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
