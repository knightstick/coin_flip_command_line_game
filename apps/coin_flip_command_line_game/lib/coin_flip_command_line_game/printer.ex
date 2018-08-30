defmodule CoinFlipCommandLineGame.Printer do
  require Logger
  alias CoinFlipCommandLineGame.Screen

  def init(_ \\ nil) do
    ExNcurses.initscr()
    ExNcurses.listen()
    ExNcurses.noecho()
    ExNcurses.keypad()
    ExNcurses.curs_set(0)

    :ok
  end

  def teardown(_ \\ nil) do
    ExNcurses.stop_listening()
    ExNcurses.endwin()
  end

  def print_full_screen(
        %Screen{user_buffer: user_buffer, display: display, prompt: prompt} = screen
      ) do
    Logger.debug("Printing full screen: " <> inspect(screen))

    ExNcurses.clear()
    ExNcurses.mvaddstr(0, 0, prompt)
    ExNcurses.addstr(user_buffer)
    ExNcurses.mvaddstr(2, 0, display)

    ExNcurses.refresh()
  end
end
