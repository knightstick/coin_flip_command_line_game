defmodule CoinFlipCommandLineGame.ScreenServer do
  require Logger

  use GenServer

  alias CoinFlipCommandLineGame.{Game, Printer, Screen}

  def start_link(printer \\ Printer, game_session) do
    GenServer.start_link(__MODULE__, %{screen: Screen.new(printer), game_session: game_session},
      name: __MODULE__
    )
  end

  def init(state) do
    state.screen.printer.init()
    {:ok, state}
  end

  def render(%Game{} = game) do
    GenServer.cast(__MODULE__, {:render, game})
  end

  def handle_cast({:render, %Game{} = game}, %{screen: %Screen{printer: printer} = screen}) do
    new_screen = Screen.update_game(screen, game)
    printer.print_full_screen(new_screen)

    {:noreply, new_screen}
  end

  def handle_info({:ex_ncurses, :key, key}, state) do
    send(state.game_session, {:key_pressed, key})

    {:noreply, state}
  end

  def handle_info(msg, state) do
    Logger.info("Unexpected info received: " <> inspect(msg))

    {:noreply, state}
  end
end
