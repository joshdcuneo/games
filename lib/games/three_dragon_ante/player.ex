defmodule Games.ThreeDragonAnte.Player do
  alias Games.ThreeDragonAnte.Card
  @type t :: %__MODULE__{
          name: String.t(),
          hand: list(Card.t())
        }

  defstruct [:name, :hand]

  @spec new(String.t()) :: t()
  def new(name) do
    %__MODULE__{name: name, hand: []}
  end
end
