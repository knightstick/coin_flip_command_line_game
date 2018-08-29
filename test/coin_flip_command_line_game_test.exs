defmodule CoinFlipCommandLineGameTest do
  use ExUnit.Case
  doctest CoinFlipCommandLineGame

  alias CoinFlipCommandLineGame.{ Game, ScreenServer }

  describe "pressing a key" do
    test "adds to the user buffer" do
      screen = ScreenServer
      game = Game.new(screen)
      screen.start_link(CoinFlipCommandLineGame.FakePrinter, game)
      game = Game.new(screen)

      :ok = Game.key_pressed(game, ?c)

      assert screen.get_user_buffer() == "c"
    end
  end
end
