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

  def count_trees_encountered(map_path, slope) do
    map =
      File.read!(map_path)
      |> String.split()
      |> Enum.map(&String.split(&1, "", trim: true))

    square_at = fn {col, row} ->
      Enum.at(map, row) |> Enum.at(col)
    end

    traverse_map(map, {0, 0}, slope)
    |> Enum.map(square_at)
    |> Enum.count(&(&1 == "#"))
  end

  def count_valid_passports(passports_path, validate_fields?) do
    is_a_year_in? = fn value, range ->
      if Regex.match?(~r/\A\d{4}\z/, value) do
        value = String.to_integer(value)
        Enum.member?(range, value)
      end
    end

    hgt_valid? = fn hgt ->
      captures = Regex.run(~r/\A(?<value>\d+)(?<unit>cm|in)\z/, hgt, capture: :all_but_first)

      if captures do
        value = String.to_integer(Enum.at(captures, 0))

        range =
          case Enum.at(captures, 1) do
            "cm" -> 150..193
            "in" -> 59..76
          end

        Enum.member?(range, value)
      end
    end

    build_passport = fn line ->
      to_map = fn [_, key, value], map ->
        Map.put(map, String.to_atom(key), value)
      end

      Regex.scan(~r/([a-z]{3}):([^\s]+)/, line)
      |> Enum.reduce(%{}, to_map)
    end

    required_fields_present? = fn passport ->
      Enum.all?([:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid], &passport[&1])
    end

    fields_valid? = fn passport ->
      is_a_year_in?.(passport.byr, 1920..2002) &&
        is_a_year_in?.(passport.iyr, 2010..2020) &&
        is_a_year_in?.(passport.eyr, 2020..2030) &&
        hgt_valid?.(passport.hgt) &&
        Regex.match?(~r/\A#[0-9a-f]{6}\z/, passport.hcl) &&
        Regex.match?(~r/\A(amb|blu|brn|gry|grn|hzl|oth)\z/, passport.ecl) &&
        Regex.match?(~r/\A\d{9}\z/, passport.pid)
    end

    valid_passports =
      File.read!(passports_path)
      |> String.trim()
      |> String.split("\n\n")
      |> Enum.map(build_passport)
      |> Enum.filter(required_fields_present?)

    if validate_fields?,
      do: Enum.count(valid_passports, fields_valid?),
      else: Enum.count(valid_passports)
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

  defp traverse_map(map, {curr_col, curr_row}, {right, down}) do
    map_width = Enum.at(map, 0) |> Enum.count()
    map_height = Enum.count(map)

    next_col = rem(curr_col + right, map_width)
    next_row = curr_row + down

    next_positions =
      if next_row < map_height,
        do: traverse_map(map, {next_col, next_row}, {right, down}),
        else: []

    [{curr_col, curr_row} | next_positions]
  end
end
