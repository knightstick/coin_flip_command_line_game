defmodule CoinFlipCommandLineGame.Game do
  alias __MODULE__
  require Logger

  defstruct printer: nil, screen: nil

  @default_printer CoinFlipCommandLineGame.Printer
  @default_screen CoinFlipCommandLineGame.ScreenServer
  def new(printer, screen) do
    %Game{printer: printer, screen: screen}
  end

  def run(options \\ []) do
    printer = Keyword.get(options, :printer, @default_printer)
    screen = Keyword.get(options, :screen, @default_screen)

    printer.init()
    screen.start_link()

    play_game(Game.new(printer, screen))
  end

  def play_game(%Game{} = game) do
    Logger.debug("Starting game")

    welcome(game.printer, game.screen)
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

  defp welcome(printer, screen) do
    print_screen(screen, printer)
  end

  defp print_screen(screen, printer) do
    printer.print_full_screen(screen.get_screen())
  end
end

      # {:ex_ncurses, :key, key} ->
      #   Logger.debug(inspect(key, label: "Key pressed: "))
      #   handle_char(to_string([key]), printer)
      #   loop(game)
