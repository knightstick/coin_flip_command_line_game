defmodule CoinFlipCommandLineGameScreenServerTest do
  use ExUnit.Case
  doctest CoinFlipCommandLineGame.ScreenServer
end

defmodule CoinFlipCommandLineGame.FakePrinter do
  alias CoinFlipCommandLineGame.Screen

  def init(), do: Agent.start(fn -> [] end, name: __MODULE__)
  def teardown(), do: Agent.stop(__MODULE__, :normal, 5000)

  def print_full_screen(%Screen{} = screen) do
    Agent.update(
      __MODULE__,
      fn printings ->
        [screen | printings]
      end,
      5000
    )
  end

  def printings() do
    Agent.get(__MODULE__, fn printings -> printings end, 5000)
  end
end
