defmodule Games.ThreeDragonAnte.PlayerTest do
  use ExUnit.Case

  alias Games.ThreeDragonAnte.{Card, Player}

  describe "new/1" do
    test "creates a new player with an empty hand" do
      player = %Player{name: "player-name"}

      assert player.name == "player-name"
      assert player.hand == []
    end
  end

  describe "ante/2" do
    test "places a card in the ante" do
      [card | _] = Card.dragons()
      player = %Player{name: "player-name", hand: [card]}

      player = Player.ante(player, card)

      assert player.ante == card
      assert player.hand == []
    end

    test "replaces a card in the ante" do
      [ante, new_ante | _] = Card.dragons()
      player = %Player{name: "player-name", hand: [new_ante], ante: ante}

      player = Player.ante(player, new_ante)

      assert player.ante == new_ante
      assert player.hand == [ante]
    end
  end

  describe "ante?/1" do
    test "returns true if the player has an ante" do
      [card | _] = Card.dragons()
      player = %Player{name: "player-name", hand: [card], ante: card}

      assert Player.ante?(player)
    end

    test "returns false if the player does not have an ante" do
      [card | _] = Card.dragons()
      player = %Player{name: "player-name", hand: [card]}

      refute Player.ante?(player)
    end
  end

  describe "card?/2" do
    test "returns true if the player has the card" do
      [card | _] = Card.dragons()
      player = %Player{name: "player-name", hand: [card]}

      assert Player.card?(player, card)
    end

    test "returns false if the player does not have the card" do
      [card | _] = Card.dragons()
      player = %Player{name: "player-name", hand: []}

      refute Player.card?(player, card)
    end
  end
end
