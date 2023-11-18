defmodule Games.Repo do
  use Ecto.Repo,
    otp_app: :games,
    adapter: Ecto.Adapters.SQLite3
end
