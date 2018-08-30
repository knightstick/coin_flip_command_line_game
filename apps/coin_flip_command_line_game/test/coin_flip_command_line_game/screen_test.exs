defmodule CoinFLipCommandLineGameScreenTest do
  use ExUnit.Case
  doctest CoinFlipCommandLineGame.Screen

  alias CoinFlipCommandLineGame.{Game, Screen}

  describe "prompt" do
    test "has a default prompt" do
      %Screen{prompt: prompt} = Screen.new()

      assert prompt == "> "
    end
  end
end
