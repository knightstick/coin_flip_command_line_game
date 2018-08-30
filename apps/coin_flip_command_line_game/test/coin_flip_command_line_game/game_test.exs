defmodule CoinFlipCommandLineGame.GameTest do
  use ExUnit.Case
  alias CoinFlipCommandLineGame.Game

  describe "init" do
    test "sets the state to ready" do
      game = %Game{game_state: :initializing}
      %Game{game_state: actual_state} = Game.init(game)

      assert actual_state == :ready
    end
  end

  describe "append_to_buffer" do
    test "adds a char to an empty buffer" do
      game = %Game{user_buffer: ""}
      %Game{user_buffer: actual_buffer} = Game.append_to_buffer(game, "c")

      assert actual_buffer == "c"
    end

    test "adds a char to end of buffer" do
      game = %Game{user_buffer: "chri"}
      %Game{user_buffer: actual_buffer} = Game.append_to_buffer(game, "s")

      assert actual_buffer == "chris"
    end
  end

  describe "execute_buffer" do
    test "terminates on quit command" do
      game = %Game{user_buffer: "quit"}
      %Game{game_state: actual_state} = Game.execute_buffer(game)

      assert actual_state == :terminating
    end

    test "resets buffer on other command" do
      game = %Game{user_buffer: "foobar"}
      %Game{user_buffer: actual_buffer} = Game.execute_buffer(game)

      assert actual_buffer == ""
    end

    test "remains ready on other command" do
      game = %Game{user_buffer: "foobar", game_state: :ready}
      %Game{game_state: actual_state} = Game.execute_buffer(game)

      assert actual_state == :ready
    end
  end
end
