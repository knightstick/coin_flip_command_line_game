defmodule CoinFlipCommandLineGame do
  @moduledoc """
  Documentation for CoinFlipCommandLineGame.
  """

  alias CoinFlipCommandLineGame.{GameSession}

  @doc """
  """
  def main(_ \\ nil) do
    GameSession.run()
  end
end
