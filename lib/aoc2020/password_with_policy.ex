defmodule Aoc2020.PasswordWithPolicy do
  def valid?(password_with_policy, policy_type) do
    [policy, password] = String.split(password_with_policy, ": ")

    [first_number, second_number, letter] =
      Regex.run(~r/\A(\d+)-(\d+)\s([a-z])\z/, policy, capture: :all_but_first)

    first_number = String.to_integer(first_number)
    second_number = String.to_integer(second_number)

    case policy_type do
      "sled_rental" ->
        letters = String.split(password, "", trim: true)
        letter_count = letters |> Enum.count(&(&1 == letter))
        Enum.member?(first_number..second_number, letter_count)

      "toboggan_corporate" ->
        positions = [first_number, second_number]
        Enum.count(positions, fn position -> String.at(password, position - 1) == letter end) == 1
    end
  end
end
