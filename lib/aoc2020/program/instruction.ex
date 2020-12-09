defmodule Aoc2020.Program.Instruction do
  @regex ~r/\A(.{3})\s([+-]\d+)\z/

  def from_string(string) do
    [operation, argument] = Regex.run(@regex, string, capture: :all_but_first)
    [String.to_atom(operation), String.to_integer(argument)]
  end
end
