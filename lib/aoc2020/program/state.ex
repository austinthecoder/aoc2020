defmodule Aoc2020.Program.State do
  def new() do
    [[], 0, 0]
  end

  def operate([stack_trace, accumulator, instruction_index], [operation, quantity]) do
    [accumulator, next_instruction_index] =
      case operation do
        :acc -> [accumulator + quantity, instruction_index + 1]
        :jmp -> [accumulator, instruction_index + quantity]
        :nop -> [accumulator, instruction_index + 1]
      end

    [
      stack_trace ++ [instruction_index],
      accumulator,
      next_instruction_index
    ]
  end
end
