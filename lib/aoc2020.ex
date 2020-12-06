defmodule Aoc2020 do
  def determine_expense_report_magic_number(expense_report_path, count) do
    entries =
      File.read!(expense_report_path)
      |> String.split()
      |> Enum.map(&String.to_integer/1)

    found_entries =
      find_entries(entries, count)
      |> List.first()

    Enum.reduce(found_entries, fn entry, acc -> entry * acc end)
  end

  defp find_entries(entries, 2) do
    for a <- entries, b <- entries, a + b == 2020, do: [a, b]
  end

  defp find_entries(entries, 3) do
    for a <- entries, b <- entries, c <- entries, a + b + c == 2020, do: [a, b, c]
  end
end
