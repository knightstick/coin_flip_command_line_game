defmodule CoinFlipCommandLineGame.Printer do
  def init(_ \\ nil), do: :ok
  def teardown(_ \\ nil), do: :ok

  def print_full_screen(string) do
    IO.puts(string)
  end
end
