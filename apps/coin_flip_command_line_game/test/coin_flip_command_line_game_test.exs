defmodule CoinFlipCommandLineGameTest do
  use ExUnit.Case
  doctest CoinFlipCommandLineGame

  alias CoinFlipCommandLineGame.{Game, ScreenServer}

  describe "pressing a key" do
    test "adds to the user buffer" do
      screen = ScreenServer
      screen.start_link(CoinFlipCommandLineGame.FakePrinter, self())
      game = Game.new(screen)

      :ok = Game.key_pressed(game, ?c)

      assert screen.get_user_buffer() == "c"
    end
  end
end