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
end
