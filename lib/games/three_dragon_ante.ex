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

  @spec setup_game(GameConfig.t()) :: {:ok, Game.t()} | {:error, :already_started}
  def setup_game(game_config) do
    game_config
    |> Game.new()
    |> Engine.setup_game()
  end

  @spec connect_to_game(Game.id()) :: {:ok, Game.t()} | {:error, :not_found}
  def connect_to_game(game_id) do
    Engine.state(game_id)
  end

  @spec join_game(Game.t(), Player.t()) :: {:ok, Game.t()} | {:error, :not_found}
  def join_game(game, player) do
    Engine.join_game(game, player)
  end

  @spec start_game(Game.t()) :: {:ok, Game.t()} | {:error, :not_found}
  def start_game(game) do
    Engine.start_game(game)
  end

  @spec ante(Game.t(), Player.t(), Card.t()) :: {:ok, Game.t()} | {:error, :not_found}
  def ante(game, player, card) do
    Engine.ante(game, player, card)
  end
end
