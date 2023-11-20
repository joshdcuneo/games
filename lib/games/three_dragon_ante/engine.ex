defmodule Games.ThreeDragonAnte.Engine do
  use GenServer
  require Logger

  alias Games.ThreeDragonAnte.{Game, GameState, Player}

  # TODO shut down when idle

  @spec setup_game(Game.t()) :: {:ok, Game.t()} | {:error, :already_started}
  def setup_game(game) do
    state = GameState.new(game)

    case GenServer.start(__MODULE__, state, name: via(game.id)) do
      {:ok, _pid} -> {:ok, game}
      {:error, :already_started} -> {:error, :already_started}
    end
  end

  @spec state(Game.id()) :: {:ok, GameState.t()} | {:error, :not_found}
  def state(game_id) do
    call(game_id, :state)
  end

  @spec join_game(Game.t(), Player.t()) :: {:ok, GameState.t()} | {:error, :not_found}
  def join_game(game, player) do
    call(game.id, {:join, player})
  end

  @spec start_game(Game.t()) :: {:ok, GameState.t()} | {:error, :not_found}
  def start_game(game) do
    call(game.id, :start)
  end

  @spec ante(Game.t(), Player.t(), Card.t()) ::
          {:ok, GameState.t()} | {:error, :not_found | :invalid_player | :invalid_card}
  def ante(game, player, card) do
    call(game.id, {:ante, player, card})
  end

  defp via(game_id) do
    {:via, Registry, {Games.GameRegistry, {__MODULE__, game_id}}}
  end

  defp call(game_id, msg) do
    case GenServer.whereis(via(game_id)) do
      nil -> {:error, :not_found}
      pid -> GenServer.call(pid, msg)
    end
  end

  @impl true
  @spec init(Game.t()) :: {:ok, map()} | {:error, :ignore}
  def init(game) do
    {:ok, game}
  end

  @impl true
  def handle_call(:state, _from, state) do
    reply(state)
  end

  @impl true
  def handle_call({:join, player}, _from, %{type: :waiting_for_players} = state) do
    state |> GameState.add_player(player) |> reply()
  end

  @impl true
  def handle_call({:join, _player}, _from, state) do
    error_reply(state)
  end

  @impl true
  def handle_call(:start, _from, %{type: :can_start} = state) do
    state |> GameState.start() |> reply()
  end

  @impl true
  def handle_call(:start, _from, state) do
    error_reply(state)
  end

  @impl true
  def handle_call({:ante, player, card}, _from, %{type: :waiting_for_ante} = state) do
    cond do
      !Game.player?(state.game, player) ->
        error_reply(state, :invalid_player)

      !Player.card?(player, card) ->
        error_reply(state, :invalid_card)

      true ->
        state |> GameState.ante(player, card) |> reply()
    end
  end

  @impl true
  def handle_call({:ante, _player, _card}, _from, state) do
    error_reply(state)
  end

  defp reply(state) do
    {:reply, {:ok, state}, state}
  end

  defp error_reply(state, error_type \\ nil) do
    {:reply, {:error, error_type || state.type}, state}
  end
end
