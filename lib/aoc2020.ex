defmodule Aoc2020 do
  def determine_expense_report_magic_number(expense_report_path, count) do
    File.read!(expense_report_path)
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> find_entry_lists_that_sum_to_2020(count)
    |> List.first()
    |> Enum.reduce(&(&1 * &2))
  end

  def count_valid_passwords(passwords_path) do
    File.read!(passwords_path)
    |> String.split("\n", trim: true)
    |> Enum.count(&password_valid?/1)
  end

  ##########

  defp find_entry_lists_that_sum_to_2020(entries, 2) do
    for a <- entries, b <- entries, a + b == 2020, do: [a, b]
  end

  defp find_entry_lists_that_sum_to_2020(entries, 3) do
    for a <- entries, b <- entries, c <- entries, a + b + c == 2020, do: [a, b, c]
  end

  defp password_valid?(policy_and_password) do
    regex = ~r/(\d+)-(\d+)\s([a-z]):\s([a-z]+)/
    [[_, low, high, letter, password]] = Regex.scan(regex, policy_and_password)

    range = String.to_integer(low)..String.to_integer(high)
    letter_count = String.split(password, "", trim: true) |> Enum.count(&(&1 == letter))
    Enum.member?(range, letter_count)
  end
end
