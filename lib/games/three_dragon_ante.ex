defmodule Games.ThreeDragonAnte do
  alias Games.ThreeDragonAnte.{Engine, Game, GameConfig}

  @spec create_game_config(map()) :: {:ok, GameConfig.t()} | {:error, Ecto.Changeset.t()}
  def create_game_config(attrs \\ %{}) do
    %GameConfig{}
    |> change_game_config(attrs)
    |> Ecto.Changeset.apply_action(:create)
  end

  @spec change_game_config(GameConfig.t(), map()) :: Ecto.Changeset.t()
  def change_game_config(game_config, attrs \\ %{}) do
    GameConfig.changeset(game_config, attrs)
  end

  @spec setup_game(GameConfig.t()) :: {:ok, Game.t()}
  def setup_game(game_config) do
    game_config
    |> GameConfig.to_game()
    |> Engine.setup_game()
  end

  @spec connect_to_game(Game.id()) :: {:ok, Game.t()}
  def connect_to_game(game_id) do
    Engine.state(game_id)
  end

  @spec join_game(Game.t(), Player.t()) :: {:ok, Game.t()}
  def join_game(game, player) do
    Engine.join_game(game, player)
  end

  @spec start_game(Game.t()) :: {:ok, Game.t()}
  def start_game(game) do
    Engine.start_game(game)
  end
end
