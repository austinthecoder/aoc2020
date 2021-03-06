defmodule Aoc2020Test do
  use ExUnit.Case
  doctest Aoc2020

  test "day 1, part 1" do
    answer = read_file("expense_report.txt") |> Aoc2020.determine_expense_report_magic_number(2)
    assert answer == 996_996
  end

  test "day 1, part 2" do
    answer = read_file("expense_report.txt") |> Aoc2020.determine_expense_report_magic_number(3)
    assert answer == 9_210_402
  end

  test "day 2, part 1" do
    answer = read_file("passwords.txt") |> Aoc2020.count_valid_passwords("sled_rental")
    assert answer == 546
  end

  test "day 2, part 2" do
    answer = read_file("passwords.txt") |> Aoc2020.count_valid_passwords("toboggan_corporate")
    assert answer == 275
  end

  test "day 3, part 1" do
    answer = read_file("map.txt") |> Aoc2020.count_trees_encountered({3, 1})
    assert answer == 225
  end

  test "day 3, part 2" do
    slopes_list = [
      {1, 1},
      {3, 1},
      {5, 1},
      {7, 1},
      {1, 2}
    ]

    answer =
      Enum.map(slopes_list, &Aoc2020.count_trees_encountered(read_file("map.txt"), &1))
      |> Enum.reduce(&(&1 * &2))

    assert answer == 1_115_775_000
  end

  test "day 4, part 1" do
    answer = read_file("passports.txt") |> Aoc2020.count_valid_passports(false)
    assert answer == 200
  end

  test "day 4, part 2" do
    answer = read_file("passports.txt") |> Aoc2020.count_valid_passports(true)
    assert answer == 116
  end

  test "day 5, part 1" do
    answer = read_file("boarding_passes.txt") |> Aoc2020.highest_boarding_pass_seat_id()
    assert answer == 871
  end

  test "day 5, part 2" do
    answer = read_file("boarding_passes.txt") |> Aoc2020.find_my_boarding_pass_seat_id()
    assert answer == 640
  end

  test "day 6, part 1" do
    answer =
      read_file("customs_declaration_form_answers.txt")
      |> Aoc2020.customs_declaration_magic_number(:anyone)

    assert answer == 6297
  end

  test "day 6, part 2" do
    answer =
      read_file("customs_declaration_form_answers.txt")
      |> Aoc2020.customs_declaration_magic_number(:everyone)

    assert answer == 3158
  end

  test "day 7, part 1" do
    answer = read_file("bag_rules.txt") |> Aoc2020.count_ancestor_bags("shiny gold")
    assert answer == 302
  end

  test "day 7, part 2" do
    answer = read_file("bag_rules.txt") |> Aoc2020.count_descendant_bags("shiny gold")
    assert answer == 4165
  end

  test "day 8, part 1" do
    answer = read_file("boot_code.txt") |> Aoc2020.run_program()
    assert answer == {:infinite_loop, 1217}
  end

  test "day 8, part 2" do
    answer = read_file("boot_code.txt") |> Aoc2020.fix_and_run_program()
    assert answer == {:done, 501}
  end

  test "day 9, part 1" do
    answer = read_file("example_xmas_data.txt") |> Aoc2020.find_xmas_invalid_number(5)
    assert answer == 127

    answer = read_file("xmas_data.txt") |> Aoc2020.find_xmas_invalid_number(25)
    assert answer == 104_054_607
  end

  test "day 9, part 2" do
    answer = read_file("example_xmas_data.txt") |> Aoc2020.find_xmas_encryption_weakness(5)
    assert answer == 62

    answer = read_file("xmas_data.txt") |> Aoc2020.find_xmas_encryption_weakness(25)
    assert answer == 13_935_797
  end

  test "day 10, part 1" do
    distribution = read_file("joltage_adapters.txt") |> Aoc2020.gather_joltage_distribution()
    answer = distribution[1] * distribution[3]
    assert answer == 2100
  end

  test "day 10, part 2, sample 1" do
    answer =
      read_file("joltage_adapters_sample1.txt") |> Aoc2020.count_joltage_adapter_arrangements()

    assert answer == 8
  end

  test "day 10, part 2, sample 2" do
    answer =
      read_file("joltage_adapters_sample2.txt") |> Aoc2020.count_joltage_adapter_arrangements()

    assert answer == 19208
  end

  test "day 10, part 2" do
    answer = read_file("joltage_adapters.txt") |> Aoc2020.count_joltage_adapter_arrangements()
    assert answer == 16_198_260_678_656
  end

  test "day 11, part 1, sample" do
    answer = read_file("seat_layout_sample.txt") |> Aoc2020.count_final_occupied_seats(1)
    assert answer == 37
  end

  test "day 11, part 1" do
    answer = read_file("seat_layout.txt") |> Aoc2020.count_final_occupied_seats(1)
    assert answer == 2113
  end

  test "day 11, part 2, sample" do
    answer = read_file("seat_layout_sample.txt") |> Aoc2020.count_final_occupied_seats(2)
    assert answer == 26
  end

  test "day 11, part 2" do
    answer = read_file("seat_layout.txt") |> Aoc2020.count_final_occupied_seats(2)
    assert answer == 1865
  end

  test "day 12, part 1, sample" do
    answer = read_file("nav_instructions_sample.txt") |> Aoc2020.calc_manhattan_distance(1)
    assert answer == 25
  end

  test "day 12, part 1" do
    answer = read_file("nav_instructions.txt") |> Aoc2020.calc_manhattan_distance(1)
    assert answer == 1956
  end

  test "day 12, part 2, sample" do
    answer = read_file("nav_instructions_sample.txt") |> Aoc2020.calc_manhattan_distance(2)
    assert answer == 286
  end

  test "day 12, part 2" do
    answer = read_file("nav_instructions.txt") |> Aoc2020.calc_manhattan_distance(2)
    assert answer == 126_797
  end

  test "day 13, part 1, sample" do
    answer = read_file("bus_notes_sample.txt") |> Aoc2020.find_bus_magic_number()
    assert answer == 295
  end

  test "day 13, part 1" do
    answer = read_file("bus_notes.txt") |> Aoc2020.find_bus_magic_number()
    assert answer == 153
  end

  test "day 13, part 2, sample" do
    answer = read_file("bus_notes_sample.txt") |> Aoc2020.find_earliest_bus_timestamp()
    assert answer == 1_068_781
  end

  test "day 13, part 2" do
    answer = read_file("bus_notes.txt") |> Aoc2020.find_earliest_bus_timestamp()
    assert answer == 1
  end

  defp read_file(name) do
    File.read!("test/files/#{name}") |> String.trim()
  end
end
