defmodule CoinFlipCommandLineGame.ScreenServer do
  require Logger

  use GenServer

  alias CoinFlipCommandLineGame.{ Printer, Screen }

  def start_link(printer \\ Printer, game_pid) do
    GenServer.start_link(__MODULE__, %{screen: Screen.new(printer), game_pid: game_pid}, name: __MODULE__)
  end

  def init(state) do
    state.screen.printer.init()
    {:ok, state}
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

  def handle_call(:get_user_buffer, _from, %{screen: %Screen{user_buffer: buffer}} = state) do
    {:reply, buffer, state}
  end

  def handle_call(:get_screen, _from, %{screen: %Screen{} = screen} = state) do
    {:reply, screen, state}
  end

  def handle_cast({:append_to_user_buffer, string}, %{screen: %Screen{} = screen} = state) do
    new_screen = Screen.user_buffer_append(screen, string)
    new_state = Map.put(state, :screen, new_screen)

    {:noreply, new_state}
  end

  def handle_info({:ex_ncurses, :key, key}, state) do
    send(state.game_pid, {:key_pressed, key})

    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.info(inspect(msg), label: "Unexpected info received: ")

    {:noreply, state}
  end
end
