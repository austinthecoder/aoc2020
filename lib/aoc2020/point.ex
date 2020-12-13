defmodule Aoc2020.Point do
  def manhattan_distance({x, y}) do
    abs(x) + abs(y)
  end

  def go_right({x, y}, dist), do: {x + dist, y}
  def go_down({x, y}, dist), do: {x, y - dist}
  def go_left({x, y}, dist), do: {x - dist, y}
  def go_up({x, y}, dist), do: {x, y + dist}

  def rotate_left(point, 0), do: point

  def rotate_left({x, y}, degrees), do: rotate_left({y * -1, x}, degrees - 90)

  def rotate_right(point, 0), do: point

  def rotate_right({x, y}, degrees), do: rotate_right({y, x * -1}, degrees - 90)
end
