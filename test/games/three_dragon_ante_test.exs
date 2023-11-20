defmodule Games.ThreeDragonAnteTest do
  use GamesWeb.ConnCase

  alias Games.ThreeDragonAnte
  alias Games.ThreeDragonAnte.{Card, Game, GameConfig, Player}

  describe "create_game_config/1" do
    test "creates a game config" do
      assert {:ok, game_config} = ThreeDragonAnte.create_game_config()
      assert game_config == %GameConfig{}
    end
  end

  setup [:create_game_config]

  describe "change_game_config/2" do
    test "changes a game config", context do
      assert %Ecto.Changeset{} = ThreeDragonAnte.change_game_config(context.game_config)
    end
  end

  describe "setup_game/1" do
    test "sets up a game", context do
      assert {:ok, game} = ThreeDragonAnte.setup_game(context.game_config)
      assert game.id != nil
    end
  end

  describe "connect_to_game/1" do
    setup [:create_game_config, :setup_game]

    test "cannot connect to a game that does not exist" do
      assert {:error, :not_found} == ThreeDragonAnte.connect_to_game("does-not-exist")
    end

    test "can connect to a game that exists", context do
      assert {:ok, game_state} = ThreeDragonAnte.connect_to_game(context.game.id)
      assert game_state.game.id == context.game.id
      assert game_state.game.players == []
      assert game_state.type == :waiting_for_players
    end
  end

  describe "join_game/2" do
    setup [:create_game_config, :setup_game]

    test "cannot join a game that does not exist" do
      assert {:error, :not_found} ==
               ThreeDragonAnte.join_game(%ThreeDragonAnte.Game{}, %ThreeDragonAnte.Player{})
    end

    test "can join a game", context do
      assert {:ok, game_state} =
               ThreeDragonAnte.join_game(context.game, %ThreeDragonAnte.Player{name: "Player 1"})

      assert game_state.game.id == context.game.id
      assert game_state.game.players == [%ThreeDragonAnte.Player{name: "Player 1"}]
      assert game_state.type == :waiting_for_players
    end

    test "more players can join the game", context do
      assert {:ok, game_state} =
               ThreeDragonAnte.join_game(
                 context.game,
                 %ThreeDragonAnte.Player{name: "Player 1"}
               )

      assert {:ok, game_state} =
               ThreeDragonAnte.join_game(
                 game_state.game,
                 %ThreeDragonAnte.Player{name: "Player 2"}
               )

      assert game_state.game.players == [
               %ThreeDragonAnte.Player{name: "Player 1"},
               %ThreeDragonAnte.Player{name: "Player 2"}
             ]

      assert game_state.type == :can_start
    end
  end

  describe "start_game/1" do
    setup [:create_game_config, :setup_game]

    test "cannot start a game that does not exist" do
      assert {:error, :not_found} == ThreeDragonAnte.start_game(%Game{})
    end

    test "cannot start a game that has not been joined", context do
      assert {:error, :waiting_for_players} == ThreeDragonAnte.start_game(context.game)
    end

    test "can start a game", context do
      ["Player 1", "Player 2"]
      |> Enum.map(fn name -> %Player{name: name} end)
      |> Enum.each(fn player -> ThreeDragonAnte.join_game(context.game, player) end)

      assert {:ok, game_state} = ThreeDragonAnte.start_game(context.game)

      assert game_state.type == :waiting_for_ante
    end
  end

  describe "ante/3" do
    setup [:create_game_config, :setup_game, :start_game]

    test "cannot ante a game that does not exist" do
      assert {:error, :not_found} ==
               ThreeDragonAnte.ante(%Game{}, %Player{}, %Card{})
    end

    test "cannot ante a game you are not playing", context do
      assert {:error, :invalid_player} ==
               ThreeDragonAnte.ante(context.game, %Player{}, %Card{})
    end

    test "cannot ante a card you do not have", context do
      assert {:error, :invalid_card} ==
               ThreeDragonAnte.ante(context.game, List.first(context.game.players), %Card{})
    end

    test "all players must ante before ante complete", context do
      [player | _] = context.game.players
      [card | _] = player.hand

      assert {:ok, game_state} =
               ThreeDragonAnte.ante(context.game, player, card)

      assert game_state.type == :waiting_for_ante
    end

    test "once all players ante it is complete", context do
      game_state =
        List.foldl(
          context.game.players,
          context.game_state,
          fn player, state ->
            {:ok, game_state} = ThreeDragonAnte.ante(state.game, player, List.first(player.hand))
            game_state
          end
        )

      # TODO something more needs to happen once ante complete
      assert game_state.type == :ante_complete
    end
  end

  defp create_game_config(_context) do
    {:ok, game_config} = ThreeDragonAnte.create_game_config()
    %{game_config: game_config}
  end

  defp setup_game(%{game_config: game_config}) do
    {:ok, game} = ThreeDragonAnte.setup_game(game_config)
    %{game: game}
  end

  defp start_game(%{game: game}) do
    ["Player 1", "Player 2"]
    |> Enum.map(fn name -> %Player{name: name} end)
    |> Enum.each(fn player -> ThreeDragonAnte.join_game(game, player) end)

    {:ok, game_state} = ThreeDragonAnte.start_game(game)

    %{game_state: game_state, game: game_state.game}
  end
end
