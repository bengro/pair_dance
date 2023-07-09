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

  @spec merge(list(TimeRange.t())) :: TimeRange.t()
  def merge(time_ranges) do
    starts = Enum.map(time_ranges, fn tr -> tr.start end)
    ends = Enum.map(time_ranges, fn tr -> tr.end end)

    %TimeRange{
      start: Enum.min(starts, DateTime),
      end:
        if Enum.member?(ends, nil) do
          nil
        else
          Enum.max(ends, DateTime)
        end
    }
  end
end
