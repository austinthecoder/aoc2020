defmodule Aoc2020.Passport do
  def from_string(string) do
    to_map = fn [_, key, value], map ->
      Map.put(map, String.to_atom(key), value)
    end

    Regex.scan(~r/([a-z]{3}):([^\s]+)/, string)
    |> Enum.reduce(%{}, to_map)
  end

  def required_fields_present?(passport) do
    Enum.all?([:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid], &passport[&1])
  end

  def fields_valid?(passport) do
    is_a_year_in?(passport.byr, 1920..2002) &&
      is_a_year_in?(passport.iyr, 2010..2020) &&
      is_a_year_in?(passport.eyr, 2020..2030) &&
      hgt_valid?(passport.hgt) &&
      Regex.match?(~r/\A#[0-9a-f]{6}\z/, passport.hcl) &&
      Regex.match?(~r/\A(amb|blu|brn|gry|grn|hzl|oth)\z/, passport.ecl) &&
      Regex.match?(~r/\A\d{9}\z/, passport.pid)
  end

  ##########

  defp is_a_year_in?(value, range) do
    if Regex.match?(~r/\A\d{4}\z/, value) do
      value = String.to_integer(value)
      Enum.member?(range, value)
    end
  end

  defp hgt_valid?(hgt) do
    captures = Regex.run(~r/\A(?<value>\d+)(?<unit>cm|in)\z/, hgt, capture: :all_but_first)

    if captures do
      value = String.to_integer(Enum.at(captures, 0))

      range =
        case Enum.at(captures, 1) do
          "cm" -> 150..193
          "in" -> 59..76
        end

      Enum.member?(range, value)
    end
  end
end
