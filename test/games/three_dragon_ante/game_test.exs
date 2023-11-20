defmodule Games.ThreeDragonAnte.GameTest do
  use ExUnit.Case

  alias Games.ThreeDragonAnte.{Deck, Game, GameConfig, Player}

  describe "add_player/2" do
    test "adds a player to the game" do
      game = %Game{id: "game-id", config: %{}, deck: %{}, players: []}
      player = %Player{name: "player-name"}

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
        players:
          ["one", "two", "three"]
          |> Enum.map(fn name ->
            %Player{name: name}
          end)
      }

      game = Game.start(game)

      assert [6, 6, 6] == Enum.map(game.players, &length(&1.hand))

      assert length(game.deck.cards) == 80 - 3 * 6
    end
  end

  describe "ante/3" do
    test "places a card in the player's ante" do
      {deck, card} = Deck.draw(Deck.random(), 1)

      game = %Game{
        id: "game-id",
        config: %GameConfig{},
        deck: deck,
        players: [%Player{name: "player-name", hand: [card]}, %Player{}]
      }

      [player, _] = game.players

      game = Game.ante(game, player, card)

      [player_one, player_two] = game.players
      assert player_one.ante == card
      assert player_two.ante == nil
    end
  end

  describe "player?/2" do
    test "returns true if the player is in the game" do
      game = %Game{
        id: "game-id",
        config: %GameConfig{},
        deck: Deck.random(),
        players: [%Player{name: "player-name"}]
      }

      assert Game.player?(game, %Player{name: "player-name"})
    end

    test "returns false if the player is not in the game" do
      game = %Game{
        id: "game-id",
        config: %GameConfig{},
        deck: Deck.random(),
        players: [%Player{name: "player-name"}]
      }

      refute Game.player?(game, %Player{name: "other-player-name"})
    end
  end
end
