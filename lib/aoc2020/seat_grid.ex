defmodule Aoc2020.SeatGrid do
  def from_string(string) do
    list =
      String.split(string)
      |> Enum.map(&String.split(&1, "", trim: true))

    Enum.with_index(list)
    |> Enum.reduce(%{}, fn {row_list, row}, acc1 ->
      row_map =
        Enum.with_index(row_list)
        |> Enum.reduce(%{}, fn {value, col}, acc2 ->
          Map.put(acc2, {col, row}, value)
        end)

      Map.merge(acc1, row_map)
    end)
  end

  def find_stable(seat_grid) do
    reducer = fn {position, _value}, new_map ->
      # If a seat is empty (L) and there are no occupied seats adjacent to it, the seat becomes occupied.
      # If a seat is occupied (#) and four or more seats adjacent to it are also occupied, the seat becomes empty.
      next_value =
        case seat_grid[position] do
          "L" ->
            if any_adjacent_occupied?(seat_grid, position), do: "L", else: "#"

          "#" ->
            if count_adjacent_occupied(seat_grid, position) > 3, do: "L", else: "#"

          value ->
            value
        end

      Map.put(new_map, position, next_value)
    end

    next_seat_grid = Enum.reduce(seat_grid, %{}, reducer)

    if next_seat_grid == seat_grid, do: next_seat_grid, else: find_stable(next_seat_grid)
  end

  def count_occupied(seat_grid) do
    occupied? = fn {_position, value} ->
      value == "#"
    end

    Enum.count(seat_grid, occupied?)
  end

  ##########

  defp any_adjacent_occupied?(seat_grid, position) do
    select_adjacent_positions(seat_grid, position)
    |> Enum.any?(fn adjacent_position -> seat_grid[adjacent_position] == "#" end)
  end

  defp count_adjacent_occupied(seat_grid, position) do
    select_adjacent_positions(seat_grid, position)
    |> Enum.count(fn adjacent_position -> seat_grid[adjacent_position] == "#" end)
  end

  # starting top-left, going clockwise, only the ones on-grid
  defp select_adjacent_positions(seat_grid, {col, row}) do
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

    on_grid? = fn position ->
      seat_grid[position]
    end

    Enum.filter(potential_positions, on_grid?)
  end
end
