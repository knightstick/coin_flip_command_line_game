defmodule CoinFlipCommandLineGame.Game do
  alias __MODULE__

  defstruct game_state: :initializing

  def new() do
    %Game{}
  end

  def init(%Game{game_state: :initializing} = game) do
    Map.put(game, :game_state, :ready)
  end
end
