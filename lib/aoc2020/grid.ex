defmodule Aoc2020.Grid do
  def from_string(string) do
    String.split(string)
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  def traverse(grid, {curr_col, curr_row}, {right, down}) do
    grid_width = Enum.at(grid, 0) |> Enum.count()
    grid_height = Enum.count(grid)

    next_col = rem(curr_col + right, grid_width)
    next_row = curr_row + down

    next_positions =
      if next_row < grid_height,
        do: traverse(grid, {next_col, next_row}, {right, down}),
        else: []

    [{curr_col, curr_row} | next_positions]
  end
end
