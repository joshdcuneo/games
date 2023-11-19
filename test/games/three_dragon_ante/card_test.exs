defmodule Games.ThreeDragonAnte.CardTest do
  use ExUnit.Case

  alias Games.ThreeDragonAnte.Card

  describe "dragons/1" do
    test "returns a list of all dragons" do
      dragons = Card.dragons()

      assert length(dragons) == 70
    end
  end

  describe "legendary_dragons/1" do
    test "returns a list of all legendary dragons" do
      legendary_dragons = Card.legendary_dragons()

      assert length(legendary_dragons) == 15
    end
  end

  describe "mortals/1" do
    test "returns a list of all mortals" do
      mortals = Card.mortals()

      assert length(mortals) == 15
    end
  end
end
