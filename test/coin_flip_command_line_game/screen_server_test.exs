defmodule CoinFlipCommandLineGameScreenServerTest do
  use ExUnit.Case
  doctest CoinFlipCommandLineGame.ScreenServer

  alias CoinFlipCommandLineGame.{ Screen, ScreenServer }

  describe "user_buffer" do
    test "can add chars to a new server user_buffer" do
      ScreenServer.start_link()
      user_buffer = ScreenServer.get_user_buffer()

      assert user_buffer == ""

      ScreenServer.append_to_user_buffer("Hello")

      user_buffer = ScreenServer.get_user_buffer()

      assert user_buffer == "Hello"
    end
  end

  test "get_screen" do
    ScreenServer.start_link()

    %Screen{} = screen = ScreenServer.get_screen()

    assert screen == Screen.new()
  end
end
