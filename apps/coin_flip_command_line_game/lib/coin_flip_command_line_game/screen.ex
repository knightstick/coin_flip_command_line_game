defmodule CoinFlipCommandLineGame.Screen do
  defstruct user_buffer: "", display: "", prompt: "", printer: nil

  alias __MODULE__
  alias CoinFlipCommandLineGame.{Game, Printer}

  @default_prompt "> "
  def new(printer \\ Printer),
    do: %Screen{
      display: new_display(),
      printer: printer,
      prompt: @default_prompt,
      user_buffer: new_buffer()
    }

  def user_buffer_append(%Screen{user_buffer: buffer} = screen, string) do
    new_buffer = buffer <> string

    Map.update!(screen, :user_buffer, fn _ -> new_buffer end)
  end

  defp new_buffer(), do: ""

  defp new_display(), do: "CoinFlipCommandLineGame"

  def update_game(%Screen{} = screen, %Game{user_buffer: game_user_buffer}) do
    Map.put(screen, :user_buffer, game_user_buffer)
  end
end
