defmodule PairDance.Domain.User.Name do
  def initials(name) when name in [nil, ""], do: "?"

  def initials(name) when is_binary(name) do
    name
    |> String.split(" ")
    |> extract_initials()
  end

  defp extract_initials([]), do: ""

  defp extract_initials([name_part | name_parts]) do
    String.slice(name_part, 0, 1) <> extract_initials(name_parts)
  end
end
