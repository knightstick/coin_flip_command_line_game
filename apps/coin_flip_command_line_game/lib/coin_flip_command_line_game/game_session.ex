defmodule CoinFlipCommandLineGame.GameSession do
  require Logger
  alias __MODULE__
  alias CoinFlipCommandLineGame.Game

  defstruct game: nil, screen: nil

  @default_screen CoinFlipCommandLineGame.ScreenServer
  def run(options \\ []) do
    screen = Keyword.get(options, :screen, @default_screen)
    screen.start_link(self())
    play_game(screen)
  end

  def new(screen), do: %GameSession{game: Game.new(), screen: screen}

  def play_game(screen) do
    Logger.debug("Starting game")

    GameSession.new(screen)
    |> loop()
    |> teardown()
  end

  def print_to_screen(game, screen), do: screen.print_full_screen(game)

  defp loop(%{game: %Game{game_state: :initializing} = game} = state) do
    Logger.debug("Initializing game: " <> inspect(game))
    initialized_game = Game.init(game)
    new_state = Map.put(state, :game, initialized_game)
    loop(new_state)
  end

  defp loop(%{game: %Game{} = game, screen: screen} = state) do
    Logger.debug("Normal loop: " <> inspect(game))
    screen.render(game)
    state
  end

  defp teardown(state) do
    Logger.debug("Tearing down: " <> inspect(state))
  end
end
