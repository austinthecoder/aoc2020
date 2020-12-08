defmodule Aoc2020.BagRules do
  def from_batch(batch) do
    String.split(batch, "\n")
    |> Enum.reduce(%{}, &populate_rules/2)
  end

  def count_ancestors(rules, color) do
    Map.keys(rules)
    |> Enum.count(&can_contain?(rules, &1, color))
  end

  def count_descendants(rules, color) do
    sum_descendants = fn {containing_color, count}, sum ->
      sum + count + count * count_descendants(rules, containing_color)
    end

    Enum.reduce(rules[color], 0, sum_descendants)
  end

  ##########

  defp can_contain?(rules, color, target_color) do
    contain? = fn {containing_color, _count} ->
      containing_color == target_color || can_contain?(rules, containing_color, target_color)
    end

    Enum.any?(rules[color], contain?)
  end

  defp populate_rules(line, map) do
    [color] = Regex.run(~r/\A([\w\s]+)\sbags\scontain/, line, capture: :all_but_first)

    populate_containing_rules = fn [digits, color], map ->
      Map.put(map, color, String.to_integer(digits))
    end

    containing_rules =
      Regex.scan(~r/(\d+)\s([\w\s]+)\sbag/, line, capture: :all_but_first)
      |> Enum.reduce(%{}, populate_containing_rules)

    Map.put(map, color, containing_rules)
  end
end
