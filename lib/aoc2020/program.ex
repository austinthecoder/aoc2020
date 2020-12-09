defmodule Aoc2020.Program do
  @instruction_regex ~r/\A(.{3})\s([+-]\d+)\z/

  def from_string(string) do
    String.split(string, "\n") |> Enum.map(&string_to_instruction/1)
  end

  def run(program) do
    run(program, [0, 0], [])
  end

  ##########

  defp run(program, state, stack_trace) do
    [accumulator, instruction_index] = state

    if Enum.member?(stack_trace, instruction_index) do
      {:infinite_loop, accumulator}
    else
      if instruction_index >= Enum.count(program) do
        {:done, accumulator}
      else
        next_state = Enum.at(program, instruction_index) |> operate(state)
        run(program, next_state, [instruction_index | stack_trace])
      end
    end
  end

  defp operate([:acc, quantity], [accumulator, instruction_index]),
    do: [accumulator + quantity, instruction_index + 1]

  defp operate([:jmp, quantity], [accumulator, instruction_index]),
    do: [accumulator, instruction_index + quantity]

  defp operate([:nop, _quantity], [accumulator, instruction_index]),
    do: [accumulator, instruction_index + 1]

  defp string_to_instruction(string) do
    [operation, argument] = Regex.run(@instruction_regex, string, capture: :all_but_first)
    [String.to_atom(operation), String.to_integer(argument)]
  end
end
