defmodule Aoc2020.SeatGrid do
  def from_string(string) do
    String.split(string)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def find_stable(seat_grid) do
    next_seat_grid = to_next(seat_grid)

    if next_seat_grid == seat_grid, do: next_seat_grid, else: find_stable(next_seat_grid)
  end

  def count_occupied(seat_grid) do
    Enum.reduce(seat_grid, 0, fn row_obj, acc1 ->
      acc1 +
        Enum.reduce(row_obj, 0, fn value, acc2 ->
          if value == "#", do: acc2 + 1, else: acc2
        end)
    end)
  end

  ##########

  defp to_next(seat_grid) do
    row_range = 0..(Enum.count(seat_grid) - 1)
    col_range = 0..(Enum.count(Enum.at(seat_grid, 0)) - 1)

    Enum.map(row_range, fn row ->
      Enum.map(col_range, fn col ->
        next_value(seat_grid, {col, row})
      end)
    end)
  end

  # If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
  # If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
  defp next_value(seat_grid, position) do
    value = value_at(seat_grid, position)

    adjacent_positions = select_adjacent_positions(seat_grid, position)

    case value do
      "L" ->
        any_adjacent_occupied? =
          adjacent_positions
          |> Enum.any?(fn adjacent_position -> occupied?(seat_grid, adjacent_position) end)

        if any_adjacent_occupied?, do: "L", else: "#"

      "#" ->
        adjacent_occupied_count =
          adjacent_positions
          |> Enum.count(fn adjacent_position -> occupied?(seat_grid, adjacent_position) end)

        if adjacent_occupied_count > 3 do
          "L"
        else
          "#"
        end

      _ ->
        value
    end
  end

  # starting top-left, going clockwise, only the ones on-grid
  defp select_adjacent_positions(seat_grid, {col, row}) do
    max_col = (Enum.at(seat_grid, 0) |> Enum.count()) - 1
    max_row = Enum.count(seat_grid) - 1

    potential_positions = [
      {col - 1, row - 1},
      {col, row - 1},
      {col + 1, row - 1},
      {col + 1, row},
      {col + 1, row + 1},
      {col, row + 1},
      {col - 1, row + 1},
      {col - 1, row}
    ]

    on_grid? = fn {col, row} ->
      col >= 0 && row >= 0 && col <= max_col && row <= max_row
    end

    Enum.filter(potential_positions, on_grid?)
  end

  defp occupied?(seat_grid, position) do
    value_at(seat_grid, position) == "#"
  end

  defp value_at(seat_grid, {col, row}) do
    Enum.at(seat_grid, row) |> Enum.at(col)
  end
end
