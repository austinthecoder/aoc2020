defmodule Aoc2020 do
  def determine_expense_report_magic_number(expense_report_path, count) do
    File.read!(expense_report_path)
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> find_entry_lists_that_sum_to_2020(count)
    |> List.first()
    |> Enum.reduce(&(&1 * &2))
  end

  def count_valid_passwords(passwords_path, policy_type) do
    File.read!(passwords_path)
    |> String.split("\n", trim: true)
    |> Enum.count(&password_valid?(&1, policy_type))
  end

  ##########

  defp find_entry_lists_that_sum_to_2020(entries, 2) do
    for a <- entries, b <- entries, a + b == 2020, do: [a, b]
  end

  defp find_entry_lists_that_sum_to_2020(entries, 3) do
    for a <- entries, b <- entries, c <- entries, a + b + c == 2020, do: [a, b, c]
  end

  defp password_valid?(policy_and_password, policy_type) do
    regex = ~r/(\d+)-(\d+)\s([a-z]):\s([a-z]+)/
    [[_, first_number, second_number, letter, password]] = Regex.scan(regex, policy_and_password)

    first_number = String.to_integer(first_number)
    second_number = String.to_integer(second_number)

    case policy_type do
      "sled_rental" ->
        letters = String.split(password, "", trim: true)
        letter_count = letters |> Enum.count(&(&1 == letter))
        Enum.member?(first_number..second_number, letter_count)

      "toboggan_corporate" ->
        positions = [first_number, second_number]
        Enum.count(positions, fn position -> String.at(password, position - 1) == letter end) == 1
    end
  end
end
