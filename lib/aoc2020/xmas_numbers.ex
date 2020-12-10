defmodule Aoc2020.XmasNumbers do
  alias Aoc2020.{Combinations}

  def from_string(string) do
    String.split(string, "\n") |> Enum.map(&String.to_integer/1)
  end

  def find_invalid(numbers, preamble), do: find_invalid(numbers, preamble, preamble)

  def find_invalid(numbers, preamble, index) do
    number = Enum.at(numbers, index)
    preamble_index_range = (index - preamble)..(index - 1)

    sum_to_number? = fn [number1, number2] ->
      number1 + number2 == number
    end

    valid? =
      Enum.slice(numbers, preamble_index_range)
      |> Combinations.build()
      |> Enum.any?(sum_to_number?)

    if valid?, do: find_invalid(numbers, preamble, index + 1), else: number
  end

  def find_encryption_weakness(numbers, invalid_number),
    do: find_encryption_weakness(numbers, invalid_number, 0, 0)

  ##########

  defp find_encryption_weakness(numbers, invalid_number, index_start, index_stop) do
    sub_numbers = Enum.slice(numbers, index_start..index_stop)
    sum = sub_numbers |> Enum.sum()

    if sum < invalid_number do
      find_encryption_weakness(numbers, invalid_number, index_start, index_stop + 1)
    else
      if sum > invalid_number do
        find_encryption_weakness(numbers, invalid_number, index_start + 1, index_stop)
      else
        Enum.min(sub_numbers) + Enum.max(sub_numbers)
      end
    end
  end
end
