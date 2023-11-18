defmodule Games.ThreeDragonAnte.GameState do
  alias Games.ThreeDragonAnte.Game

  @type state_type :: :waiting_for_players | :can_start | :waiting_for_ante

  @type t :: %__MODULE__{
          type: state_type(),
          game: Game.t()
        }

  defstruct [:type, :game]

  @spec new(Game.t()) :: t()
  def new(game) do
    %__MODULE__{type: :waiting_for_players, game: game}
  end

  @spec add_player(t(), String.t()) :: t()
  def add_player(state, name) do
    game = Game.add_player(state.game, name)

    type =
      if length(game.players) >= 2 do
        :can_start
      else
        :waiting_for_players
      end

    %__MODULE__{state | game: game, type: type}
  end

  @spec start(t()) :: t()
  def start(state) do
    game = Game.start(state.game)

    %__MODULE__{state | game: game, type: :waiting_for_ante}
  end
end
