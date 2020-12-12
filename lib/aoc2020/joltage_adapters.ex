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

  def count_arrangements(joltage_ratings) do
    outlet_rating = 0
    device_rating = Enum.at(joltage_ratings, -1) + 3
    ratings = [outlet_rating | joltage_ratings] ++ [device_rating]

    chunk_fun = fn gap, acc ->
      if gap do
        {:cont, [gap | acc]}
      else
        {:cont, acc, []}
      end
    end

    after_fun = fn
      [] -> {:cont, []}
      acc -> {:cont, acc, []}
    end

    build_gap_map(ratings)
    |> Enum.chunk_while([], chunk_fun, after_fun)
    |> Enum.reduce(1, fn list, acc ->
      acc * gap_size_multiplier(Enum.count(list))
    end)
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

  def build_gap_map(ratings) do
    ratings_size = Enum.count(ratings)
    inner_indexes = 1..(ratings_size - 2)

    gap? = fn index ->
      Enum.at(ratings, index + 1) - Enum.at(ratings, index - 1) < 4
    end

    Enum.map(inner_indexes, gap?)
  end

  def gap_size_multiplier(0), do: 1
  def gap_size_multiplier(1), do: 2
  def gap_size_multiplier(2), do: 4

  def gap_size_multiplier(size) do
    gap_size_multiplier(size - 1) + gap_size_multiplier(size - 2) + gap_size_multiplier(size - 3)
  end
end
