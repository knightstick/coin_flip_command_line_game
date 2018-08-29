defmodule CoinFlipCommandLineGame.Screen do
  defstruct user_buffer: "", display: "", prompt: "", printer: nil, game: nil

  alias __MODULE__
  alias CoinFlipCommandLineGame.{ Game, Printer }

  @default_prompt "> "
  def new(printer \\ Printer, %Game{} = game), do: %Screen{
    display: new_display(),
    game: game,
    printer: printer,
    prompt: @default_prompt,
    user_buffer: new_buffer(),
  }

  def user_buffer_append(%Screen{user_buffer: buffer} = screen, string) do
    new_buffer = buffer <> string

    Map.update!(screen, :user_buffer, fn _ -> new_buffer end)
  end

  defp new_buffer(), do: ""

  defp new_display(), do: "CoinFlipCommandLineGame"
end
