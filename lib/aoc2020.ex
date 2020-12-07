defmodule Aoc2020 do
  alias Aoc2020.{Passport, PasswordWithPolicy, TextMap}

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
    |> Enum.count(&PasswordWithPolicy.valid?(&1, policy_type))
  end

  def count_trees_encountered(map_path, slope) do
    map =
      File.read!(map_path)
      |> String.split()
      |> Enum.map(&String.split(&1, "", trim: true))

    square_at = fn {col, row} ->
      Enum.at(map, row) |> Enum.at(col)
    end

    TextMap.traverse(map, {0, 0}, slope)
    |> Enum.map(square_at)
    |> Enum.count(&(&1 == "#"))
  end

  def count_valid_passports(passports_path, validate_fields?) do
    valid_passports =
      File.read!(passports_path)
      |> String.trim()
      |> String.split("\n\n")
      |> Enum.map(&Passport.from_string/1)
      |> Enum.filter(&Passport.required_fields_present?/1)

    if validate_fields?,
      do: Enum.count(valid_passports, &Passport.fields_valid?/1),
      else: Enum.count(valid_passports)
  end

  ##########

  defp find_entry_lists_that_sum_to_2020(entries, 2) do
    for a <- entries, b <- entries, a + b == 2020, do: [a, b]
  end

  defp find_entry_lists_that_sum_to_2020(entries, 3) do
    for a <- entries, b <- entries, c <- entries, a + b + c == 2020, do: [a, b, c]
  end
end
