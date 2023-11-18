defmodule Games.ThreeDragonAnte.Game do
  alias Games.ThreeDragonAnte.GameConfig

  @type id :: String.t()

  @type t :: %__MODULE__{
          id: id(),
          config: GameConfig.t(),
          deck: Deck.t(),
          players: list(Player.t())
        }

  defstruct [:id, :config, :deck, :players]

  @spec add_player(t(), Player.t()) :: t()
  def add_player(game, player) do
    players = game.players ++ [player]
    %__MODULE__{game | players: players}
  end

  @spec start(t()) :: t()
  def start(game) do
    # TODO deal cards
    game
  end
end
