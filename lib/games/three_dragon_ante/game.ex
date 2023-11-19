defmodule Games.ThreeDragonAnte.Game do
  alias Games.ThreeDragonAnte.{Deck, GameConfig, Player}

  @type id :: String.t()

  @type t :: %__MODULE__{
          id: id(),
          config: GameConfig.t(),
          deck: Deck.t(),
          players: list(Player.t())
        }

  defstruct [:id, :config, :deck, :players]

  @hand_size 6

  @spec new(GameConfig.t()) :: t()
  def new(config \\ GameConfig.new()) do
    %__MODULE__{
      id: generate_game_id(),
      config: config,
      deck: Deck.random(),
      players: []
    }
  end

  defp generate_game_id do
    :crypto.strong_rand_bytes(20) |> Base.url_encode64() |> String.replace(~r/[^a-z0-9]/, "")
  end

  @spec add_player(t(), Player.t()) :: t()
  def add_player(game, player) do
    players = game.players ++ [player]
    %__MODULE__{game | players: players}
  end

  @spec start(t()) :: t()
  def start(game) do
    {deck, players} = deal_cards(game.deck, game.players, @hand_size)

    %__MODULE__{game | deck: deck, players: players}
  end

  defp deal_cards(initial_deck, initial_players, count) do
    Enum.reduce(initial_players, {initial_deck, []}, fn player, {deck, players} ->
      {hand, remaining_deck} = Deck.draw(deck, count)
      {remaining_deck, players ++ [%Player{player | hand: hand}]}
    end)
  end
end
