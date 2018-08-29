defmodule CoinFlipCommandLineGame.ScreenServer do
  require Logger

  use GenServer

  alias CoinFlipCommandLineGame.{ Game, Printer, Screen }

  def start_link(printer \\ Printer, %Game{} = game) do
    GenServer.start_link(__MODULE__, Screen.new(printer, game), name: __MODULE__)
  end

  def init(screen) do
    screen.printer.init()
    {:ok, screen}
  end

  def get_screen() do
    GenServer.call(__MODULE__, :get_screen, 5000)
  end

  def get_user_buffer() do
    GenServer.call(__MODULE__, :get_user_buffer, 5000)
  end

  def append_to_user_buffer(string) do
    GenServer.cast(__MODULE__, {:append_to_user_buffer, string})
    render()
  end

  def render() do
    screen = get_screen()
    screen.printer.print_full_screen(screen)
  end

  def handle_call(:get_user_buffer, _from, %Screen{user_buffer: buffer} = state) do
    {:reply, buffer, state}
  end

  def handle_call(:get_screen, _from, %Screen{} = state) do
    {:reply, state, state}
  end

  def handle_cast({:append_to_user_buffer, string}, %Screen{} = state) do
    new_state = Screen.user_buffer_append(state, string)

    {:noreply, new_state}
  end

  def handle_info({:ex_ncurses, :key, key}, state) do
    CoinFlipCommandLineGame.Game.key_pressed(state.game, key)
    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.info(inspect(msg), label: "Unexpected info received: ")

    {:noreply, state}
  end
end
