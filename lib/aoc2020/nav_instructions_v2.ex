defmodule Aoc2020.NavInstructionsV2 do
  alias Aoc2020.{NavInstructions}

  def from_string(string), do: NavInstructions.from_string(string)

  def travel(nav_instructions), do: travel(nav_instructions, {0, 0}, {10, 1})

  ##########

  defp travel([], sp, _wp), do: sp

  defp travel([{action, value} | nav_instructions], sp, wp) do
    case action do
      "E" ->
        travel(nav_instructions, sp, go_east(wp, value))

      "S" ->
        travel(nav_instructions, sp, go_south(wp, value))

      "W" ->
        travel(nav_instructions, sp, go_west(wp, value))

      "N" ->
        travel(nav_instructions, sp, go_north(wp, value))

      "L" ->
        travel(nav_instructions, sp, rotate_degrees_left(wp, value))

      "R" ->
        travel(nav_instructions, sp, rotate_degrees_right(wp, value))

      "F" ->
        travel(nav_instructions, go_forward(sp, wp, value), wp)
    end
  end

  def go_east({x, y}, dist), do: {x + dist, y}
  def go_south({x, y}, dist), do: {x, y - dist}
  def go_west({x, y}, dist), do: {x - dist, y}
  def go_north({x, y}, dist), do: {x, y + dist}

  def rotate_degrees_left(point, 0), do: point

  def rotate_degrees_left({x, y}, degrees), do: rotate_degrees_left({y * -1, x}, degrees - 90)

  def rotate_degrees_right(point, 0), do: point

  def rotate_degrees_right({x, y}, degrees), do: rotate_degrees_right({y, x * -1}, degrees - 90)

  def go_forward({sp_x, sp_y}, {wp_x, wp_y}, dist) do
    new_sp_x = wp_x * dist + sp_x
    new_sp_y = wp_y * dist + sp_y
    {new_sp_x, new_sp_y}
  end
end
