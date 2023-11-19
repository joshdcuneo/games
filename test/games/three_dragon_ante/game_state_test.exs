defmodule Games.ThreeDragonAnte.GameStateTest do
  use ExUnit.Case

  alias Games.ThreeDragonAnte.{Game, GameState, Player}

  describe "new/1" do
    test "creates a new game state for a game" do
      game = Game.new()
      game_state = GameState.new(game)

      assert game_state.game == game
      assert game_state.type == :waiting_for_players
    end
  end

  describe "add_player/2" do
    test "adds a player to the game" do
      game = Game.new()
      player = Player.new("player-name")

      game_state = GameState.new(game)
      game_state = GameState.add_player(game_state, player)

      assert length(game_state.game.players) == 1
      assert game_state.type == :waiting_for_players
    end

    test "changes the game state to :can_start when there are two players" do
      game = Game.new()
      player = Player.new("player-name")

      game_state = GameState.new(game)
      game_state = GameState.add_player(game_state, player)
      game_state = GameState.add_player(game_state, player)

      assert game_state.type == :can_start
    end
  end

  describe "start/1" do
    test "starts the game" do
      game = Game.new()
      player = Player.new("player-name")

      game_state = GameState.new(game)
      game_state = GameState.add_player(game_state, player)
      game_state = GameState.add_player(game_state, player)
      game_state = GameState.start(game_state)

      assert game_state.type == :waiting_for_ante

      assert Enum.all?(game_state.game.players, fn player ->
               length(player.hand) == 6
             end)
    end
  end
end
