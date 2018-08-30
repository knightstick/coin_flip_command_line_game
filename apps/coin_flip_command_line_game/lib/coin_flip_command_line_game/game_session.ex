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

  defp loop(%{game: %Game{game_state: :terminating} = game} = state) do
    Logger.debug("Terminating game: " <> inspect(game))
    state
  end

  @timeout 30_000
  defp loop(%{game: %Game{} = game, screen: screen} = state) do
    Logger.debug("Normal loop: " <> inspect(game))
    screen.render(game)

    receive do
      {:key_pressed, key} ->
        Logger.debug("Key pressed: " <> inspect(key))
        handle_key_press(state, key)
        |> loop()
      msg ->
        Logger.debug("Received unhandled message: " <> inspect(msg))
        loop(state)
    after
      @timeout -> state
    end
  end

  defp teardown(state) do
    Logger.debug("Tearing down: " <> inspect(state))
  end

  defp handle_key_press(%{game: %Game{} = game, screen: _screen} = state, ?\n) do
    new_game = Game.execute_buffer(game)
    Map.put(state, :game, new_game)
  end

  defp handle_key_press(%{game: %Game{} = game, screen: _screen} = state, key) when is_integer(key) do
    new_game = Game.append_to_buffer(game, to_string([key]))
    Map.put(state, :game, new_game)
  end
end
