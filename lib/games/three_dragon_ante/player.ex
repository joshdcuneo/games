defmodule Games.ThreeDragonAnte.Player do
  alias Games.ThreeDragonAnte.Card

  @type t :: %__MODULE__{
          name: String.t(),
          hand: list(Card.t()),
          ante: Card.t() | nil
        }

  defstruct name: nil,
            hand: [],
            ante: nil

  @spec new(map()) :: t()
  def new(attrs \\ %{}) do
    struct(__MODULE__, attrs)
  end

  @spec ante(t(), Card.t()) :: t()
  def ante(player, card) do
    hand = List.delete(player.hand, card)

    if ante?(player) do
      %__MODULE__{player | hand: [player.ante | hand], ante: card}
    else
      %__MODULE__{player | ante: card, hand: hand}
    end
  end

  @spec ante?(t()) :: boolean()
  def ante?(player), do: player.ante != nil

  @spec card?(t(), Card.t()) :: boolean()
  def card?(player, card) do
    Enum.member?(player.hand, card)
  end
end
