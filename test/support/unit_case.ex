defmodule PairDance.UnitCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      import PairDance.UnitCase
    end
  end
end
