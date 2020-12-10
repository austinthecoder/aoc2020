defmodule Aoc2020.JoltageRatings do
  def from_string(string) do
    String.split(string, "\n")
    |> Enum.map(&String.to_integer/1)
    |> Enum.sort()
  end

  def gather_distribution(joltage_ratings) do
    outlet_rating = 0
    device_rating = Enum.at(joltage_ratings, -1) + 3
    ratings = [outlet_rating | joltage_ratings] ++ [device_rating]

    last_index = Enum.count(ratings) - 1
    distribution = %{1 => 0, 2 => 0, 3 => 0}

    gather_distribution(ratings, 0, last_index, distribution)
  end

  ##########

  defp gather_distribution(_ratings, index, last_index, distribution) when index == last_index,
    do: distribution

  defp gather_distribution(ratings, index, last_index, distribution) do
    next_index = index + 1
    difference = Enum.at(ratings, next_index) - Enum.at(ratings, index)
    distribution = Map.put(distribution, difference, distribution[difference] + 1)
    gather_distribution(ratings, next_index, last_index, distribution)
  end
end
