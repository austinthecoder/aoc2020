defmodule Aoc2020 do
  alias Aoc2020.{
    Combinations,
    BagRules,
    BoardingPass,
    Grid,
    JoltageRatings,
    NavInstructions,
    NavInstructionsV2,
    Passport,
    PasswordWithPolicy,
    Point,
    Program,
    SeatGrid,
    XmasNumbers
  }

  def determine_expense_report_magic_number(expense_report, count) do
    expense_report
    |> String.split()
    |> Enum.map(&String.to_integer/1)
    |> find_entry_combination_that_sums_to(count, 2020)
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

  def find_xmas_invalid_number(xmas_data, preamble) do
    XmasNumbers.from_string(xmas_data) |> XmasNumbers.find_invalid(preamble)
  end

  def find_xmas_encryption_weakness(xmas_data, preamble) do
    xmas_numbers = XmasNumbers.from_string(xmas_data)
    invalid_number = XmasNumbers.find_invalid(xmas_numbers, preamble)
    XmasNumbers.find_encryption_weakness(xmas_numbers, invalid_number)
  end

  def gather_joltage_distribution(joltage_adapter_data) do
    JoltageRatings.from_string(joltage_adapter_data)
    |> JoltageRatings.gather_distribution()
  end

  def count_joltage_adapter_arrangements(joltage_adapter_data) do
    JoltageRatings.from_string(joltage_adapter_data)
    |> JoltageRatings.count_arrangements()
  end

  def count_final_occupied_seats(seat_layout, type) do
    SeatGrid.from_string(seat_layout)
    |> SeatGrid.find_stable(type)
    |> SeatGrid.count_occupied()
  end

  def calc_manhattan_distance(nav_instructions, rules_version) do
    point =
      case rules_version do
        1 ->
          NavInstructions.from_string(nav_instructions)
          |> NavInstructions.travel()

        2 ->
          NavInstructionsV2.from_string(nav_instructions)
          |> NavInstructionsV2.travel()
      end

    Point.manhattan_distance(point)
  end

  def find_bus_magic_number(bus_notes) do
    [estimate, bus_ids] = String.split(bus_notes, "\n")
    estimate = String.to_integer(estimate)

    bus_ids =
      String.split(bus_ids, ",")
      |> Enum.reduce([], fn bus_id, acc ->
        if bus_id != "x", do: acc ++ [String.to_integer(bus_id)], else: acc
      end)

    bus_id_with_wait_mins_list =
      Enum.reduce(bus_ids, [], fn bus_id, acc ->
        wait_mins = ceil(estimate / bus_id) * bus_id - estimate
        acc ++ [[bus_id, wait_mins]]
      end)

    [bus_id, wait_mins] =
      Enum.sort(bus_id_with_wait_mins_list, fn [_bus_id, wait_mins],
                                               [_other_bus_id, other_wait_mins] ->
        wait_mins < other_wait_mins
      end)
      |> List.first()

    bus_id * wait_mins
  end

  @spec find_earliest_bus_timestamp(binary) :: any
  def find_earliest_bus_timestamp(bus_notes) do
    [_estimate, bus_ids] = String.split(bus_notes, "\n")

    bus_id_and_position_list =
      String.split(bus_ids, ",")
      |> Enum.with_index()
      |> Enum.reduce([], fn {bus_id, index}, acc ->
        if bus_id != "x", do: acc ++ [[String.to_integer(bus_id), index]], else: acc
      end)

    IO.inspect(Enum.map(bus_id_and_position_list, fn [b, p] -> {b, p} end))

    # find_timestamp(bus_id_and_position_list)

    # find_multiplier(bus_id_and_position_list, 0, 0, 1)
  end

  def x(a) do
    IO.inspect(a)

    # r =
    # ((((((((13 * a + 3) / 41 + 13) / 997 + 21) / 23 + 32) / 19 + 42) / 29 + 44) / 619 + 50) / 37 +
    #  61) / 17

    # r = (7 * a + 1) / 13
    r1 = 7 * a
    r2 = (7 * a + 1) / 13
    r3 = (7 * a + 4) / 59
    r4 = (7 * a + 6) / 31

    l = [r1, r2, r3, r4]

    if Enum.any?(l, fn r -> r != round(r) end) do
      x(a + 1)
    else
      a
    end
  end

  ##########

  defp find_multiplier(bus_id_and_position_list, index, total, multiplier) do
    if index == Enum.count(bus_id_and_position_list) - 1 do
      multiplier
    else
      [bus_id, position] = Enum.at(bus_id_and_position_list, index)

      total = (total + position) / bus_id

      if total == round(total) do
        find_multiplier(bus_id_and_position_list, index + 1, total, multiplier)
      else
        find_multiplier(bus_id_and_position_list, 0, 1, multiplier + 1)
      end
    end
  end

  # defp find_timestamp(bus_id_and_position_list) do
  #   [highest_bus_id, position] =
  #     Enum.sort(bus_id_and_position_list, fn [bus_id, _position],
  #                                            [other_bus_id, _other_position] ->
  #       bus_id > other_bus_id
  #     end)
  #     |> List.first()

  #   find_timestamp(bus_id_and_position_list, highest_bus_id, position)
  # end

  # defp find_timestamp(bus_id_and_position_list, step, timestamp) do
  #   has_remainder? = fn [bus_id, position] ->
  #     rem(timestamp + position, bus_id) != 0
  #   end

  #   if Enum.any?(bus_id_and_position_list, has_remainder?),
  #     do: find_timestamp(bus_id_and_position_list, step, timestamp + step),
  #     else: timestamp
  # end

  defp calc_seat_ids(batch_boarding_passes) do
    String.split(batch_boarding_passes)
    |> Enum.map(&BoardingPass.calc_seat_id/1)
  end

  defp find_entry_combination_that_sums_to(entries, 2, sum) do
    sums_to? = fn [entry1, entry2] ->
      entry1 + entry2 == sum
    end

    Combinations.build(entries) |> Enum.find(sums_to?)
  end

  defp find_entry_combination_that_sums_to(entries, 3, sum) do
    for(a <- entries, b <- entries, c <- entries, a + b + c == sum, do: [a, b, c])
    |> List.first()
  end
end
