defmodule CoinFLipCommandLineGameScreenTest do
  use ExUnit.Case
  doctest CoinFlipCommandLineGame.Screen

  alias CoinFlipCommandLineGame.Screen

  describe "user_buffer" do
    test "can add chars to a new user_buffer" do
      screen = %Screen{}

      %Screen{user_buffer: actual} = Screen.user_buffer_append(screen, "c")

      assert actual == "c"
    end

    test "can add chars to a existing user_buffer" do
      screen = %Screen{user_buffer: "initial"}

      %Screen{user_buffer: actual} = Screen.user_buffer_append(screen, "c")

      assert actual == "initialc"
    end
  end

  describe "prompt" do
    test "has a default prompt" do
      %Screen{prompt: prompt} = Screen.new()

      assert prompt == "> "
    end
  end
end
