defmodule Games.ThreeDragonAnte.Card do
  defstruct [:power, :type, :name]

  @type t :: %__MODULE__{
          power: integer(),
          type: :standard_dragon | :legendary_dragon | :mortal,
          name: atom()
        }

  @dragon_sets %{
    black_dragon: [1, 2, 3, 5, 6, 7, 9],
    blue_dragon: [1, 2, 4, 6, 7, 9, 11],
    brass_dragon: [1, 2, 3, 4, 5, 7, 9],
    bronze_dragon: [1, 3, 6, 7, 8, 9, 11],
    copper_dragon: [1, 3, 5, 6, 7, 8, 10],
    gold_dragon: [2, 4, 6, 8, 9, 11, 13],
    green_dragon: [1, 2, 4, 5, 6, 8, 10],
    red_dragon: [2, 3, 5, 7, 8, 10, 12],
    silver_dragon: [2, 3, 6, 7, 8, 10, 12],
    white_dragon: [1, 2, 3, 4, 5, 6, 8]
  }

  @legendary_dragons [
    {:bahamut, 13},
    {:black_raider, 8},
    {:blue_overlord, 10},
    {:brass_sultan, 8},
    {:bronze_warlord, 10},
    {:chromatic_wyrmling, 1},
    {:copper_trickster, 9},
    {:dracolich, 10},
    {:gold_monarch, 12},
    {:green_schemer, 5},
    {:metallic_wyrmling, 1},
    {:red_destroyer, 11},
    {:silver_seer, 11},
    {:tiamat, 13},
    {:white_hunter, 7}
  ]

  @mortals [
    {:archmage, 9},
    {:dragonrider, 6},
    {:dragonslayer, 8},
    {:druid, 6},
    {:fool, 3},
    {:illusionist, 4},
    {:kobold, 2},
    {:merchant_prince, 5},
    {:priest, 5},
    {:princess, 4},
    {:prophet, 10},
    {:queen, 7},
    {:sorcerer, 8},
    {:thief, 7},
    {:wyrmpriest, 5}
  ]

  @spec dragons() :: list(t())
  def dragons do
    Enum.flat_map(@dragon_sets, &color_dragons/1)
  end

  defp color_dragons({color, powers}) do
    for power <- powers do
      %__MODULE__{
        power: power,
        type: :standard_dragon,
        name: color
      }
    end
  end

  @spec legendary_dragons() :: list(t())
  def legendary_dragons do
    for {name, power} <- @legendary_dragons do
      %__MODULE__{
        power: power,
        type: :legendary_dragon,
        name: name
      }
    end
  end

  @spec mortals() :: list(t())
  def mortals do
    for {name, power} <- @mortals do
      %__MODULE__{
        power: power,
        type: :mortal,
        name: name
      }
    end
  end
end
