defmodule Setup do
  @script "shared.exs"
  require Logger

  def setup(_directory, 0, attempted_locations) do
    Logger.error("Could not find #{@script} at the attempted locations:
    \n#{Enum.join(attempted_locations, "\n")}")

    raise "Could not find #{@script}"
  end

  def setup(directory, n, attempted_locations) do
    path = Path.join(directory, @script)

    if File.exists?(path) do
      Code.require_file(path)
      Shared.setup(__DIR__)
    else
      absolute_folder_loc = path |> Path.absname() |> Path.expand()
      setup(Path.join(directory, ".."), n - 1, [absolute_folder_loc | attempted_locations])
    end
  end
end

Setup.setup(".", 5, [])

defmodule Tests do
  use ExUnit.Case, async: true
  import Shared

  check(that: Fibonacci.fib(0), is_equal_to: 0)
  check(that: Fibonacci.fib(1), is_equal_to: 1)
  check(that: Fibonacci.fib(2), is_equal_to: 1)
  check(that: Fibonacci.fib(3), is_equal_to: 2)
  check(that: Fibonacci.fib(4), is_equal_to: 3)
  check(that: Fibonacci.fib(5), is_equal_to: 5)
  check(that: Fibonacci.fib(6), is_equal_to: 8)
  check(that: Fibonacci.fib(7), is_equal_to: 13)
end
