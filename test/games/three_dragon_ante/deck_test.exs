defmodule Games.ThreeDragonAnte.DeckTest do
  use ExUnit.Case

  alias Games.ThreeDragonAnte.Deck

  describe "random/0" do
    test "returns a deck with 80 cards" do
      deck = Deck.random()

      assert length(deck.cards) == 80
    end
  end

  describe "draw/2" do
    test "returns a hand of cards and a deck with the remaining cards" do
      deck = Deck.random()

      {hand, deck} = Deck.draw(deck, 5)

      assert length(hand) == 5
      assert length(deck.cards) == 75
    end
  end
end
