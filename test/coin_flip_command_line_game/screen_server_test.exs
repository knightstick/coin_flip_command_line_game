defmodule CoinFlipCommandLineGameScreenServerTest do
  use ExUnit.Case
  doctest CoinFlipCommandLineGame.ScreenServer

  alias CoinFlipCommandLineGame.{ Game, Screen, ScreenServer }

  setup do
    printer = CoinFlipCommandLineGame.FakePrinter
    printer.init()

    game = Game.new(ScreenServer)
    ScreenServer.start_link(printer, self())

    on_exit fn ->
      printer.teardown()
    end

    [printer: printer, game: game]
  end

  describe "user_buffer" do
    test "can add chars to a new server user_buffer" do
      user_buffer = ScreenServer.get_user_buffer()
      assert user_buffer == ""

      ScreenServer.append_to_user_buffer("Hello")
      user_buffer = ScreenServer.get_user_buffer()

      assert user_buffer == "Hello"
    end
  end

  test "get_screen", %{printer: printer} do
    %Screen{} = screen = ScreenServer.get_screen()

    assert screen == Screen.new(printer)
  end

  test "render", %{printer: printer} do
    ScreenServer.render()

    assert printer.printings == [Screen.new(printer)]
  end
end

defmodule CoinFlipCommandLineGame.FakePrinter do
  alias CoinFlipCommandLineGame.Screen

  def init(), do: Agent.start(fn -> [] end, name: __MODULE__)
  def teardown(), do: Agent.stop(__MODULE__, :normal, 5000)

  def print_full_screen(%Screen{} = screen) do
    Agent.update(__MODULE__, fn printings ->
      [screen | printings]
    end, 5000)
  end

  def printings() do
    Agent.get(__MODULE__, fn printings -> printings end, 5000)
  end
end
