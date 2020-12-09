defmodule Aoc2020 do
  alias Aoc2020.{BagRules, BoardingPass, Grid, Passport, PasswordWithPolicy, Program}

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

  def customs_declaration_magic_number(customs_declaration_form_answers, type) do
    reducer =
      case type do
        :anyone -> &MapSet.union/2
        :everyone -> &MapSet.intersection/2
      end

    to_answer_set = fn line ->
      String.split(line, "", trim: true) |> MapSet.new()
    end

    to_yes_counts = fn group ->
      String.split(group, "\n")
      |> Enum.map(to_answer_set)
      |> Enum.reduce(reducer)
      |> Enum.count()
    end

    customs_declaration_form_answers
    |> String.split("\n\n")
    |> Enum.map(to_yes_counts)
    |> Enum.sum()
  end

  def count_ancestor_bags(batch_bag_rules, color) do
    BagRules.from_batch(batch_bag_rules) |> BagRules.count_ancestors(color)
  end

  def count_descendant_bags(batch_bag_rules, color) do
    BagRules.from_batch(batch_bag_rules) |> BagRules.count_descendants(color)
  end

  def run_program(code) do
    Program.from_string(code) |> Program.run()
  end

  def fix_and_run_program(code) do
    program = Program.from_string(code)

    add_modified_program = fn {[operation, quantity], instruction_index}, programs ->
      case operation do
        :jmp ->
          programs ++ [List.replace_at(program, instruction_index, [:nop, quantity])]

        :nop ->
          programs ++ [List.replace_at(program, instruction_index, [:jmp, quantity])]

        _ ->
          programs
      end
    end

    done? = fn {result, _state} -> result == :done end

    program
    |> Enum.with_index()
    |> Enum.reduce([], add_modified_program)
    |> Enum.map(&Program.run/1)
    |> Enum.find(done?)
  end

  def find_invalid_number(xmas_data, preamble) do
    numbers = String.split(xmas_data, "\n") |> Enum.map(&String.to_integer/1)
    last_index = Enum.count(numbers) - 1

    invalid? = fn index ->
      number = Enum.at(numbers, index)
      prev_indexes = (index - preamble)..(index - 1)

      list =
        for(
          prev_index1 <- prev_indexes,
          prev_index2 <- prev_indexes,
          prev_index1 != prev_index2 &&
            Enum.at(numbers, prev_index1) + Enum.at(numbers, prev_index2) == number,
          do: true
        )

      Enum.empty?(list)
    end

    invalid_index = Enum.find(preamble..last_index, invalid?)

    Enum.at(numbers, invalid_index)
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
