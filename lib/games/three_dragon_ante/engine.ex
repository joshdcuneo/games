defmodule Games.ThreeDragonAnte.Engine do
  use GenServer
  require Logger

  alias Games.ThreeDragonAnte.{GameState, Player}

  # TODO shut down when idle

  @spec setup_game(Game.t()) :: {:ok, Game.t()}
  def setup_game(game) do
    state = GameState.new(game)
    {:ok, _pid} = GenServer.start(__MODULE__, state, name: via(game.id))

    {:ok, game}
  end

  @spec state(Game.id()) :: {:ok, GameState.t()}
  def state(game_id) do
    state = GenServer.call(via(game_id), :state)
    {:ok, state}
  end

  @spec join_game(Game.t(), Player.t()) :: {:ok, GameState.t()}
  def join_game(game, player) do
    state = GenServer.call(via(game.id), {:join, player})

    {:ok, state}
  end

  @spec start_game(Game.t()) :: {:ok, GameState.t()}
  def start_game(game) do
    state = GenServer.call(via(game.id), :start)

    {:ok, state}
  end

  defp via(game_id) do
    {:via, Registry, {Games.GameRegistry, {__MODULE__, game_id}}}
  end

  @impl true
  @spec init(Game.t()) :: {:ok, map()} | {:error, :ignore}
  def init(game) do
    {:ok, game}
  end

  @impl true
  def handle_call(:state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_call({:join, player}, _from, %{type: :waiting_for_players} = state) do
    state |> GameState.add_player(player) |> reply()
  end

  @impl true
  def handle_call(:start, _from, %{type: :can_start} = state) do
    state |> GameState.start() |> reply()
  end

  defp reply(state) do
    {:reply, state, state}
  end
end
