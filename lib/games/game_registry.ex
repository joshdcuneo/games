defmodule Games.GameRegistry do
  @moduledoc """
  The game registry is a process that keeps track of all the games
  that are currently running. It is used to look up a game by its
  ID, and to start a new game.
  """

  def child_spec do
    {Registry, name: __MODULE__, keys: :unique}
  end
end
