defmodule Aoc2020 do
  def determine_expense_report_magic_number(expense_report_path) do
    entries =
      File.read!(expense_report_path)
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    [entry1, entry2] =
      entries
      |> stream_pairs()
      |> Enum.find(fn [x, y] -> x + y == 2020 end)

    entry1 * entry2
  end

  defp stream_pairs([]), do: []

  defp stream_pairs([head | tail]) do
    Stream.map(tail, fn item -> [head, item] end) |> Stream.concat(stream_pairs(tail))
  end
end
