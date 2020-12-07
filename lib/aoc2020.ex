defmodule Aoc2020 do
  alias Aoc2020.{BoardingPass, Grid, Passport, PasswordWithPolicy}

  def determine_expense_report_magic_number(expense_report, count) do
    expense_report
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> find_entry_lists_that_sum_to_2020(count)
    |> List.first()
    |> Enum.reduce(&(&1 * &2))
  end

  def count_valid_passwords(batch_passwords, policy_type) do
    batch_passwords
    |> String.split("\n", trim: true)
    |> Enum.count(&PasswordWithPolicy.valid?(&1, policy_type))
  end

  def count_trees_encountered(map, slope) do
    grid = Grid.from_string(map)

    square_at = fn {col, row} ->
      Enum.at(grid, row) |> Enum.at(col)
    end

    Grid.traverse(grid, {0, 0}, slope)
    |> Enum.map(square_at)
    |> Enum.count(&(&1 == "#"))
  end

  def count_valid_passports(batch_passports, validate_fields?) do
    valid_passports =
      batch_passports
      |> String.split("\n\n")
      |> Enum.map(&Passport.from_string/1)
      |> Enum.filter(&Passport.required_fields_present?/1)

    if validate_fields?,
      do: Enum.count(valid_passports, &Passport.fields_valid?/1),
      else: Enum.count(valid_passports)
  end

  def highest_boarding_pass_seat_id(batch_boarding_passes) do
    calc_seat_ids(batch_boarding_passes) |> Enum.max()
  end

  def find_my_boarding_pass_seat_id(batch_boarding_passes) do
    gap? = fn [seat_id1, seat_id2] ->
      seat_id2 - seat_id1 == 2
    end

    calc_seat_ids(batch_boarding_passes)
    |> Enum.sort()
    |> Enum.chunk_every(2, 1)
    |> Enum.find(gap?)
    |> Enum.at(0)
    |> Kernel.+(1)
  end

  ##########

  defp calc_seat_ids(batch_boarding_passes) do
    String.split(batch_boarding_passes)
    |> Enum.map(&BoardingPass.calc_seat_id/1)
  end

  defp find_entry_lists_that_sum_to_2020(entries, 2) do
    for a <- entries, b <- entries, a + b == 2020, do: [a, b]
  end

  defp find_entry_lists_that_sum_to_2020(entries, 3) do
    for a <- entries, b <- entries, c <- entries, a + b + c == 2020, do: [a, b, c]
  end
end
