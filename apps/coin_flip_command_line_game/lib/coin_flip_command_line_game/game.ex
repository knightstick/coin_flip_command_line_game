defmodule CoinFlipCommandLineGame.Game do
  alias __MODULE__

  defstruct game_state: :initializing, user_buffer: ""

  def new() do
    %Game{}
  end

  def init(%Game{game_state: :initializing} = game) do
    Map.put(game, :game_state, :ready)
  end

  def append_to_buffer(%Game{} = game, string) do
    Map.update!(game, :user_buffer, fn buffer -> buffer <> string end)
  end

  @quit_command "quit"
  def execute_buffer(%Game{user_buffer: @quit_command} = game) do
    Map.put(game, :game_state, :terminating)
  end

  def execute_buffer(%Game{} = game) do
    Map.put(game, :user_buffer, "")
  end
end
