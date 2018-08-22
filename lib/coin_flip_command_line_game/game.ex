defmodule CoinFlipCommandLineGame.Game do
  alias CoinFlipCommandLineGame.Printer

  @default_printer Printer
  @wait_time 5000
  def run(options \\ []) do
    printer = Keyword.get(options, :printer, @default_printer)
    timer = Keyword.get(options, :timer, :timer)

    printer.init()
    printer.print_full_screen("> \n\nCoinFlipCommandLineGame\n")

    timer.sleep(@wait_time)
    printer.teardown()
  end
end
