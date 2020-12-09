defmodule Aoc2020.Program do
  alias Aoc2020.Program.{State, Instruction}

  def from_string(string) do
    String.split(string, "\n") |> Enum.map(&Instruction.from_string/1)
  end

  def run(program) do
    run(program, State.new())
  end

  defp run(program, state) do
    [stack_trace, _, instruction_index] = state

    instruction = Enum.at(program, instruction_index)

    if instruction do
      if !Enum.member?(stack_trace, instruction_index) do
        state = State.operate(state, instruction)
        run(program, state)
      else
        {:infinite_loop, state}
      end
    else
      {:done, state}
    end
  end
end
