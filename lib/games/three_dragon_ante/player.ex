defmodule Games.ThreeDragonAnte.Player do
  @type t :: %__MODULE__{
          name: String.t()
        }

  defstruct [:name]
end
