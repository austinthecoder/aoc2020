defmodule Aoc2020.BagRules do
  def from_batch(batch) do
    String.split(batch, "\n")
    |> Enum.reduce(%{}, &add_rule/2)
  end

  def count_ancestors(rules, color) do
    Map.keys(rules)
    |> Enum.count(&can_contain?(rules, &1, color))
  end

  ##########

  defp can_contain?(rules, color, target_color) do
    contain? = fn containing_color ->
      containing_color == target_color || can_contain?(rules, containing_color, target_color)
    end

    Enum.any?(rules[color], contain?)
  end

  defp add_rule(line, map) do
    [color] = Regex.run(~r/\A([\w\s]+)\sbags\scontain/, line, capture: :all_but_first)

    containing_colors =
      Regex.scan(~r/\d+\s([\w\s]+)\sbag/, line, capture: :all_but_first)
      |> Enum.map(&Enum.at(&1, 0))

    Map.put(map, color, containing_colors)
  end
end
