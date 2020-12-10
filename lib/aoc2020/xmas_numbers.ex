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
end
