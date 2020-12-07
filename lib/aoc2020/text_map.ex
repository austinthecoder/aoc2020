defmodule Aoc2020.TextMap do
  def traverse(map, {curr_col, curr_row}, {right, down}) do
    map_width = Enum.at(map, 0) |> Enum.count()
    map_height = Enum.count(map)

    next_col = rem(curr_col + right, map_width)
    next_row = curr_row + down

    next_positions =
      if next_row < map_height,
        do: traverse(map, {next_col, next_row}, {right, down}),
        else: []

    [{curr_col, curr_row} | next_positions]
  end
end
