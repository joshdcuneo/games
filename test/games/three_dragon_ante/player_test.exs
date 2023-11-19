defmodule Games.ThreeDragonAnte.PlayerTest do
  use ExUnit.Case

  alias Games.ThreeDragonAnte.Player

  describe "new/1" do
    test "creates a new player with an empty hand" do
      player = Player.new("player-name")

      assert player.name == "player-name"
      assert player.hand == []
    end
  end
end
