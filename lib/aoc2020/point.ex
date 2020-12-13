defmodule Aoc2020.Point do
  def manhattan_distance({x, y}) do
    abs(x) + abs(y)
  end
end
