defmodule CoinFlipCommandLineGame.Game do
  alias __MODULE__
  require Logger

  defstruct printer: nil, screen: nil

  @default_screen CoinFlipCommandLineGame.ScreenServer
  def new(screen) do
    %Game{screen: screen}
  end

  def run(options \\ []) do
    screen = Keyword.get(options, :screen, @default_screen)

    screen.start_link()

    play_game(Game.new(screen))
  end

  def play_game(%Game{} = game) do
    Logger.debug("Starting game")

    welcome(game.screen)
    loop(game)

    teardown(game)
  end

  def key_pressed(%Game{} = game, key) do
    game.screen.append_to_user_buffer(to_string([key]))
  end

  def teardown(%Game{}) do
    Logger.debug("Tearing down")
  end


  defp loop(%Game{} = game) do
    receive do
      {:key_pressed, key} ->
        Logger.debug(inspect(key), label: "Key pressed: ")
        Logger.debug(inspect(game), label: "Game: ")
        key_pressed(game, key)
        loop(game)
    after
      2000 -> nil
    end
  end

  defp welcome(screen) do
    print_screen(screen)
  end

  defp print_screen(screen) do
    screen.render()
  end
end

      # {:ex_ncurses, :key, key} ->
      #   Logger.debug(inspect(key, label: "Key pressed: "))
      #   handle_char(to_string([key]), printer)
      #   loop(game)
