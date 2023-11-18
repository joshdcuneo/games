defmodule Games.ThreeDragonAnte.Deck do
  alias Games.ThreeDragonAnte.{Card, Deck}

  @type t :: %__MODULE__{
          cards: list(Card.t())
        }

  defstruct [:cards]

  def random do
    %Deck{cards: random_cards()}
  end

  defp random_cards do
    dragons =
      Card.dragons()
      |> Enum.shuffle()

    uniques =
      Card.legendary_dragons()
      |> Enum.concat(Card.mortals())
      |> Enum.shuffle()
      |> Enum.take(10)

    Enum.shuffle(dragons ++ uniques)
  end
end
