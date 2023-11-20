defmodule Games.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      GamesWeb.Telemetry,
      Games.Repo,
      {Ecto.Migrator,
       repos: Application.fetch_env!(:games, :ecto_repos), skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:games, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Games.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Games.Finch},
      # Start a worker by calling: Games.Worker.start_link(arg)
      # {Games.Worker, arg},
      Games.GameRegistry.child_spec(),
      # Start to serve requests, typically the last entry
      GamesWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Games.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    GamesWeb.Endpoint.config_change(changed, removed)
    :ok
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
