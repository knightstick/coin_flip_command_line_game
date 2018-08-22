defmodule CoinFlipCommandLineGame.Game do
  alias CoinFlipCommandLineGame.Printer

  @default_printer Printer
  def run(options \\ []) do
    printer = Keyword.get(options, :printer, @default_printer)

    printer.print_full_screen("> \n\nCoinFlipCommandLineGame\n")
  end
end
