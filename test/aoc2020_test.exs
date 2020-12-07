defmodule Aoc2020Test do
  use ExUnit.Case
  doctest Aoc2020

  test "day 1, part 1" do
    answer = Aoc2020.determine_expense_report_magic_number("test/expense_report.txt", 2)
    assert answer == 996_996
  end

  test "day 1, part 2" do
    answer = Aoc2020.determine_expense_report_magic_number("test/expense_report.txt", 3)
    assert answer == 9_210_402
  end

  test "day 2, part 1" do
    assert Aoc2020.count_valid_passwords("test/passwords.txt", "sled_rental") == 546
  end

  test "day 2, part 2" do
    assert Aoc2020.count_valid_passwords("test/passwords.txt", "toboggan_corporate") == 275
  end

  test "day 3, part 1" do
    assert Aoc2020.count_trees_encountered("test/map.txt", {3, 1}) == 225
  end

  test "day 3, part 2" do
    map_path = "test/map.txt"

    slopes_list = [
      {1, 1},
      {3, 1},
      {5, 1},
      {7, 1},
      {1, 2}
    ]

    answer =
      Enum.map(slopes_list, &Aoc2020.count_trees_encountered(map_path, &1))
      |> Enum.reduce(&(&1 * &2))

    assert answer == 1_115_775_000
  end

  test "day 4, part 1" do
    assert Aoc2020.count_valid_passports("test/passports.txt", false) == 200
  end

  test "day 4, part 2" do
    assert Aoc2020.count_valid_passports("test/passports.txt", true) == 116
  end
end
