defmodule CoinFlipCommandLineGame.GameTest do
  use ExUnit.Case
  doctest CoinFlipCommandLineGame.Game

  alias CoinFlipCommandLineGame.Game

  describe "run" do
    test "prints a full screen" do
      {:ok, _pid} = FakePrinter.start_link()

      expected = "> \n\nCoinFlipCommandLineGame\n"

      # TODO: Mox?
      Game.run(printer: FakePrinter)

      printed = FakePrinter.printed()
      assert(printed == expected)
    end
  end
end

defmodule FakePrinter do
  def start_link, do: Agent.start_link(fn -> "" end, name: __MODULE__)

  def printed do
    Agent.get(__MODULE__, fn state -> state end, 5000)
  end

  def print_full_screen(string) do
    Agent.update(__MODULE__, fn state -> state <> string end, 5000)
  end
end
