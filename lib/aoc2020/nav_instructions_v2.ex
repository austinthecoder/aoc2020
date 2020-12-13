defmodule Aoc2020.NavInstructionsV2 do
  alias Aoc2020.{NavInstructions, Point}

  def from_string(string), do: NavInstructions.from_string(string)

  def travel(nav_instructions), do: travel(nav_instructions, {0, 0}, {10, 1})

  ##########

  defp travel([], sp, _wp), do: sp

  defp travel([{action, value} | nav_instructions], sp, wp) do
    case action do
      "E" ->
        travel(nav_instructions, sp, Point.go_right(wp, value))

      "S" ->
        travel(nav_instructions, sp, Point.go_down(wp, value))

      "W" ->
        travel(nav_instructions, sp, Point.go_left(wp, value))

      "N" ->
        travel(nav_instructions, sp, Point.go_up(wp, value))

      "L" ->
        travel(nav_instructions, sp, Point.rotate_left(wp, value))

      "R" ->
        travel(nav_instructions, sp, Point.rotate_right(wp, value))

      "F" ->
        travel(nav_instructions, go_forward(sp, wp, value), wp)
    end
  end

  def go_forward({sp_x, sp_y}, {wp_x, wp_y}, dist) do
    {sp_x + wp_x * dist, sp_y + wp_y * dist}
  end
end
