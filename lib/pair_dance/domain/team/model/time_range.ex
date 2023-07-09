defmodule PairDance.Domain.Team.TimeRange do
  alias __MODULE__

  @enforce_keys [:start, :end]
  defstruct [:start, :end]

  @type t() :: %__MODULE__{
          start: DateTime.t(),
          end: DateTime.t()
        }

  @doc """
  Returns true if the first argument precedes or is in the same place as the second one.
  Compatible with Enum.sort/2
  """
  @spec compare(TimeRange.t(), TimeRange.t()) :: boolean
  def compare(tr1, tr2) do
    case compare_time(tr1.end, tr2.end) do
      :lt ->
        true

      :gt ->
        false

      :eq ->
        case compare_time(tr1.start, tr2.start) do
          :lt -> true
          :gt -> false
          :eq -> true
        end
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
