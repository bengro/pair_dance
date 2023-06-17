defmodule PairDance.E2eCase do
  use ExUnit.CaseTemplate
  alias Wallaby.Query

  using do
    quote do
      import PairDance.E2eCase
      use ExUnit.Case, async: false
      use Wallaby.Feature
    end
  end

  def data_qa(value) do
    Query.css("[data-qa=#{value}]")
  end
end
