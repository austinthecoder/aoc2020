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

    # last_index = Enum.count(ratings) - 1

    # count_arrangements(ratings, 0, last_index)
    cnt2(ratings) + 1
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

  def count_arrangements(_ratings, index, last_index) when index == last_index, do: 0
  def count_arrangements(_ratings, index, last_index) when last_index - index < 3, do: 1

  def count_arrangements(ratings, index, last_index) do
    number = Enum.at(ratings, index)

    count1 = count_arrangements(ratings, index + 1, last_index)

    if Enum.at(ratings, index + 2) - number < 4 do
      count2 = count1 + count_arrangements(ratings, index + 2, last_index)

      if Enum.at(ratings, index + 3) - number < 4 do
        count2 + count_arrangements(ratings, index + 3, last_index)
      else
        count2
      end
    else
      count1
    end
  end

  def cnt2([]), do: 0

  def cnt2(ratings) do
    ratings_size = Enum.count(ratings)

    if ratings_size < 3 do
      1
    else
      inner_indexes = 1..(ratings_size - 2)

      can_remove? = fn index ->
        Enum.at(ratings, index + 1) - Enum.at(ratings, index - 1) < 4
      end

      optional_indexes = Enum.filter(inner_indexes, can_remove?)

      reducer = fn index, acc ->
        next_ratings = [Enum.at(ratings, index - 1) | Enum.slice(ratings, (index + 1)..-1)]
        acc + cnt2(next_ratings)
      end

      Enum.count(optional_indexes) + Enum.reduce(optional_indexes, 0, reducer)
    end
  end
end
