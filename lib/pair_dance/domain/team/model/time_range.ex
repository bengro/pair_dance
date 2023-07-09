defmodule PairDance.Domain.Team.TimeRange do
  alias __MODULE__

  @enforce_keys [:start, :end]
  defstruct [:start, :end]

  @type t() :: %__MODULE__{
          start: DateTime.t(),
          end: DateTime.t()
        }

  @spec compare(TimeRange.t(), TimeRange.t()) :: :lt | :eq | :gt
  def compare(tr1, tr2) do
    case compare_time(tr1.end, tr2.end) do
      :lt -> :lt
      :gt -> :gt
      :eq -> compare_time(tr1.start, tr2.start)
    end
  end

  defp compare_time(t1, t2) do
    cond do
      is_nil(t1) and is_nil(t2) -> :eq
      is_nil(t1) -> :gt
      is_nil(t2) -> :lt
      true -> DateTime.compare(t1, t2)
    end
  end
end
