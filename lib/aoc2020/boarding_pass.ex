defmodule Aoc2020.BoardingPass do
  def calc_seat_id(boarding_pass) do
    {row_operations, col_operations} =
      boarding_pass
      |> String.split("", trim: true)
      |> Enum.map(&to_operation/1)
      |> Enum.split(7)

    locate(0..127, row_operations) * 8 + locate(0..7, col_operations)
  end

  ##########

  defp locate([number], _), do: number

  defp locate(numbers, [operation | operations]) do
    amount = (Enum.count(numbers) / 2) |> round()
    amount = amount * operation

    Enum.take(numbers, amount) |> locate(operations)
  end

  defp to_operation("F"), do: 1
  defp to_operation("B"), do: -1
  defp to_operation("L"), do: 1
  defp to_operation("R"), do: -1
end
