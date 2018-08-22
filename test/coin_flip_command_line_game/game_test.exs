defmodule CoinFlipCommandLineGame.GameTest do
  use ExUnit.Case
  doctest CoinFlipCommandLineGame.Game

  alias CoinFlipCommandLineGame.Game

  describe "run" do
    setup do
      {:ok, _pid} = FakePrinter.start_link()
      {:ok, _pid} = FakeTimer.start_link()

      [printer: FakePrinter, timer: FakeTimer]
    end

    def run(printer: printer, timer: timer), do: Game.run(printer: printer, timer: timer)

    test "prints a full screen", %{ printer: printer, timer: timer } do
      expected = "> \n\nCoinFlipCommandLineGame\n"

      run(printer: printer, timer: timer)

      assert(printer.printed() == expected)
    end

    test "waits for a while", %{ printer: printer, timer: timer } do
      expected = 5000

      run(printer: printer, timer: timer)

      assert(timer.waited() == expected)
    end
  end
end

defmodule FakePrinter do
  def start_link, do: Agent.start_link(fn -> "" end, name: __MODULE__)

  def init(_ \\ nil), do: :ok

  def teardown(_ \\ nil), do: :ok

  def print_full_screen(string) do
    Agent.update(__MODULE__, fn state -> state <> string end, 5000)
  end

  def printed do
    Agent.get(__MODULE__, fn state -> state end, 5000)
  end
end

defmodule FakeTimer do
  def start_link, do: Agent.start_link(fn -> 0 end, name: __MODULE__)

  def sleep(time) do
    Agent.update(__MODULE__, fn state -> state + time end, 5000)
  end

  def waited do
    Agent.get(__MODULE__, fn state -> state end, 5000)
  end
end
