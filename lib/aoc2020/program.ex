defmodule Aoc2020.Program do
  defmodule Instruction do
    @regex ~r/\A(.{3})\s([+-]\d+)\z/

    def from_string(string) do
      [operation, argument] = Regex.run(@regex, string, capture: :all_but_first)
      [operation, String.to_integer(argument)]
    end

    def execute(["acc", quantity], accumulator, line), do: [accumulator + quantity, line + 1]
    def execute(["jmp", quantity], accumulator, line), do: [accumulator, line + quantity]
    def execute(["nop", _quantity], accumulator, line), do: [accumulator, line + 1]
  end

  def from_string(string) do
    String.split(string, "\n") |> Enum.map(&Instruction.from_string/1)
  end

  def execute(instructions, executed_lines, accumulator, line) do
    if Enum.member?(executed_lines, line) do
      accumulator
    else
      [accumulator, next_line] =
        Enum.at(instructions, line)
        |> Instruction.execute(accumulator, line)

      execute(
        instructions,
        List.insert_at(executed_lines, -1, line),
        accumulator,
        next_line
      )
    end
  end
end
