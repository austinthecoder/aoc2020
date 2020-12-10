defmodule Aoc2020.Combinations do
  def build(list), do: build(list, 0, Enum.count(list) - 1)

  ##########

  defp build(_list, index, last_index) when index == last_index, do: []

  defp build(list, index, last_index) do
    item = Enum.at(list, index)
    subset_range = (index + 1)..last_index
    sub_list = Enum.slice(list, subset_range)

    combine(item, sub_list) ++ build(list, index + 1, last_index)
  end

  defp combine(item, list) do
    Enum.map(list, fn other_item -> [item, other_item] end)
  end
end
