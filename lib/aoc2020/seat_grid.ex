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

  def find_stable(seat_grid, type) do
    reducer = fn {position, _value}, new_map ->
      next_value =
        case seat_grid[position] do
          "L" ->
            if occupy?(seat_grid, position, type), do: "#", else: "L"

          "#" ->
            if unoccupy?(seat_grid, position, type), do: "L", else: "#"

          value ->
            value
        end

      Map.put(new_map, position, next_value)
    end

    next_seat_grid = Enum.reduce(seat_grid, %{}, reducer)

    if next_seat_grid == seat_grid, do: next_seat_grid, else: find_stable(next_seat_grid, type)
  end

  def count_occupied(seat_grid) do
    occupied? = fn {_position, value} ->
      value == "#"
    end

    Enum.count(seat_grid, occupied?)
  end

  ##########

  defp positions_to_consider(seat_grid, position, type) do
    case type do
      1 -> select_adjacent_positions(seat_grid, position)
      2 -> select_seated_adjacent_positions(seat_grid, position)
    end
  end

  # If no adjacent seats are occupied
  defp occupy?(seat_grid, position, type) do
    positions = positions_to_consider(seat_grid, position, type)

    occupied? = fn pos -> seat_grid[pos] == "#" end
    !Enum.any?(positions, occupied?)
  end

  # If four or more adjacent seats are occupied
  defp unoccupy?(seat_grid, position, type) do
    positions = positions_to_consider(seat_grid, position, type)

    num =
      case type do
        1 -> 3
        2 -> 4
      end

    occupied? = fn pos -> seat_grid[pos] == "#" end
    Enum.count(positions, occupied?) > num
  end

  defp select_seated_adjacent_positions(seat_grid, {col, row}) do
    potential_positions = [
      find_next_seated_position(seat_grid, {col, row}, {-1, -1}),
      find_next_seated_position(seat_grid, {col, row}, {0, -1}),
      find_next_seated_position(seat_grid, {col, row}, {1, -1}),
      find_next_seated_position(seat_grid, {col, row}, {1, 0}),
      find_next_seated_position(seat_grid, {col, row}, {1, 1}),
      find_next_seated_position(seat_grid, {col, row}, {0, 1}),
      find_next_seated_position(seat_grid, {col, row}, {-1, 1}),
      find_next_seated_position(seat_grid, {col, row}, {-1, 0})
    ]

    nil? = fn position -> !position end

    Enum.reject(potential_positions, nil?)
  end

  def find_next_seated_position(seat_grid, position, position_change) do
    next_position = move_position(position, position_change)
    next_value = seat_grid[next_position]

    case next_value do
      "L" -> next_position
      "#" -> next_position
      "." -> find_next_seated_position(seat_grid, next_position, position_change)
      nil -> nil
    end
  end

  defp move_position({col, row}, {col_change, row_change}) do
    {col + col_change, row + row_change}
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
