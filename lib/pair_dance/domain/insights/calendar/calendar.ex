defmodule PairDance.Domain.Insights.Calendar do
  alias __MODULE__

  alias PairDance.Domain.Insights.Calendar.Week

  @enforce_keys [:weeks]
  defstruct [:weeks]

  @type t() :: %__MODULE__{
          weeks: list(Week.t())
        }

  @spec build(list(AssignedTask.t())) :: Calendar.t()
  def build(assignments, options \\ []) do
    %{num_weeks: num_weeks, end_date: end_date} =
      Enum.into(options, %{num_weeks: 9, end_date: Date.utc_today()})

    {weeks, _} =
      Enum.map_reduce(1..num_weeks, end_date, fn _, last_date ->
        week = Week.build(last_date, assignments)
        {week, Date.add(week.start_date, -1)}
      end)

    %Calendar{
      weeks: Enum.reverse(weeks)
    }
  end
end
