defmodule CoinFlipCommandLineGame.Screen do
  defstruct user_buffer: "", display: "", prompt: ""

  alias __MODULE__

  @default_prompt "> "
  def new(), do: %Screen{
    user_buffer: new_buffer(),
    display: new_display(),
    prompt: @default_prompt
  }

  def user_buffer_append(%Screen{user_buffer: buffer} = screen, string) do
    new_buffer = buffer <> string

    Map.update!(screen, :user_buffer, fn _ -> new_buffer end)
  end

  defp new_buffer(), do: ""

  defp new_display(), do: "CoinFlipCommandLineGame"
end