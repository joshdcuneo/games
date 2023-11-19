defmodule Games.ThreeDragonAnte.GameConfig do
  use Ecto.Schema
  import Ecto.Changeset

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
end
