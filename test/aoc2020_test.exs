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

  defp read_file(name) do
    File.read!("test/files/#{name}") |> String.trim()
  end
end
