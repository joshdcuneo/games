defmodule Games.ThreeDragonAnte.GameTest do
  use ExUnit.Case

  alias Games.ThreeDragonAnte.{Deck, Game, GameConfig, Player}

  describe "add_player/2" do
    test "adds a player to the game" do
      game = %Game{id: "game-id", config: %{}, deck: %{}, players: []}
      player = Player.new("player-name")

      game = Game.add_player(game, player)

      assert length(game.players) == 1
    end
  end

  describe "start/1" do
    test "deals cards to each player" do
      game = %Game{
        id: "game-id",
        config: %GameConfig{},
        deck: Deck.random(),
        players: [Player.new("one"), Player.new("two"), Player.new("three")]
      }

      game = Game.start(game)

      assert [6, 6, 6] == Enum.map(game.players, &length(&1.hand))

      assert length(game.deck.cards) == 80 - 3 * 6
    end
  end
end
