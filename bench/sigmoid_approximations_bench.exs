defmodule SigmoidApproximationsBench.Macros do
  defmacro bench_func(desc, fun) do
    quote do
      bench unquote(desc) do
        @iters
         |> Enum.map(unquote(fun))
      end
    end
  end
end

defmodule SigmoidApproximationsBench do
  use Benchfella
  import SigmoidApproximationsBench.Macros

  @moduledoc """
  Benchmarks the speed of the sigmoid function and approximations by
  running each candidate over @iters. All functions are normalized
  between 0 and 1.

  Interpreting results: compare them relative to the no-op function, and
  don't forget the numbers that Benchfella spits out are per 100 runs as
  per @iters
  """

  @iters -50..50

  bench_func("no-op: identify function", fn(i) -> i end)

  bench_func("baseline: sigmoid function", fn(i) -> 1 / (1 + :math.exp(-i)) end)

  bench_func("approx: tanh", fn(i) -> (:math.tanh(i) + 1) / 2 end)
  bench_func("approx: hard sigmoid", fn(i) -> max(0,min(1, (i * 0.2) + 0.5)) end)
  bench_func("approx: x/1+|x|", fn(i) -> ((0.5 * i) / (1 + abs(i))) + 0.5 end)
end
