defmodule Games.ThreeDragonAnte.GameConfig do
  use Ecto.Schema
  import Ecto.Changeset

  alias Games.ThreeDragonAnte.{Deck, Game}

  @type t :: %__MODULE__{
          id: nil
        }

  embedded_schema do
  end

  def changeset(game_config, params \\ %{}) do
    game_config
    |> cast(params, [])
  end

  def new do
    %__MODULE__{}
  end

  def to_game(game_config) do
    %Game{
      id: generate_game_id(),
      config: game_config,
      deck: Deck.random(),
      players: []
    }
  end

  defp generate_game_id do
    :crypto.strong_rand_bytes(20) |> Base.url_encode64() |> String.replace(~r/[^a-z0-9]/, "")
  end
end
