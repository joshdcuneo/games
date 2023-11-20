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
      player = %Player{name: "player-name"}

      game_state =
        Game.new()
        |> GameState.new()
        |> GameState.add_player(player)

      assert length(game_state.game.players) == 1
      assert game_state.type == :waiting_for_players
    end

    test "changes the game state to :can_start when there are two players" do
      player = %Player{name: "player-name"}

      game_state =
        Game.new()
        |> GameState.new()
        |> GameState.add_player(player)
        |> GameState.add_player(player)

      assert game_state.type == :can_start
    end
  end

  describe "start/1" do
    test "starts the game" do
      player = %Player{name: "player-name"}

      game_state =
        Game.new()
        |> GameState.new()
        |> GameState.add_player(player)
        |> GameState.add_player(player)
        |> GameState.start()

      assert game_state.type == :waiting_for_ante

      assert Enum.all?(game_state.game.players, fn player ->
               length(player.hand) == 6
             end)
    end
  end

  describe "ante/3" do
    setup :create_started_game

    test "places a card in the player's ante", context do
      [player_one, player_two] = context.game_state.game.players
      [card | _] = player_one.hand
      game_state = GameState.ante(context.game_state, player_one, card)

      [player_one, player_two] = game_state.game.players
      assert game_state.type == :waiting_for_ante
      assert player_one.ante != nil
      assert player_two.ante == nil
    end

    test "changes the game state to :ante_complete when all players have ante'd", context do
      [player_one, player_two] = context.game_state.game.players
      [player_one_card | _] = player_one.hand
      [player_two_card | _] = player_two.hand

      game_state =
        context.game_state
        |> GameState.ante(player_one, player_one_card)
        |> GameState.ante(player_two, player_two_card)

      assert game_state.type == :ante_complete
    end
  end

  defp create_started_game(_context) do
    player = %Player{name: "player-name"}

    game_state =
      Game.new()
      |> GameState.new()
      |> GameState.add_player(player)
      |> GameState.add_player(player)
      |> GameState.start()

    %{game_state: game_state}
  end
end
