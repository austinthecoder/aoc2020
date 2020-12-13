defmodule Aoc2020.NavInstructions do
  def from_string(string) do
    String.split(string, "\n")
    |> Enum.reduce([], fn line, acc ->
      {action, value} = String.split_at(line, 1)
      acc ++ [{action, String.to_integer(value)}]
    end)
  end

  def travel(nav_instructions), do: travel(nav_instructions, {0, 0}, :east)

  ##########

  defp travel([], point, _facing), do: point

  defp travel([{action, value} | nav_instructions], {x, y}, facing) do
    case action do
      "N" ->
        travel(nav_instructions, {x, y + value}, facing)

      "S" ->
        travel(nav_instructions, {x, y - value}, facing)

      "E" ->
        travel(nav_instructions, {x + value, y}, facing)

      "W" ->
        travel(nav_instructions, {x - value, y}, facing)

      "L" ->
        travel(nav_instructions, {x, y}, orient(facing, action, value))

      "R" ->
        travel(nav_instructions, {x, y}, orient(facing, action, value))

      "F" ->
        case facing do
          :east -> travel(nav_instructions, {x + value, y}, facing)
          :north -> travel(nav_instructions, {x, y + value}, facing)
          :west -> travel(nav_instructions, {x - value, y}, facing)
          :south -> travel(nav_instructions, {x, y - value}, facing)
        end
    end
  end

  defp orient(:east, _action, 180), do: :west
  defp orient(:north, _action, 180), do: :south
  defp orient(:west, _action, 180), do: :east
  defp orient(:south, _action, 180), do: :north

  defp orient(:east, "L", 90), do: :north
  defp orient(:east, "L", 270), do: :south
  defp orient(:north, "L", 90), do: :west
  defp orient(:north, "L", 270), do: :east
  defp orient(:west, "L", 90), do: :south
  defp orient(:west, "L", 270), do: :north
  defp orient(:south, "L", 90), do: :east
  defp orient(:south, "L", 270), do: :west

  defp orient(:east, "R", 90), do: :south
  defp orient(:east, "R", 270), do: :north
  defp orient(:north, "R", 90), do: :east
  defp orient(:north, "R", 270), do: :west
  defp orient(:west, "R", 90), do: :north
  defp orient(:west, "R", 270), do: :south
  defp orient(:south, "R", 90), do: :west
  defp orient(:south, "R", 270), do: :east
end
