defmodule GamesWeb.ThreeDragonAnteLive.Index do
  use GamesWeb, :live_view

  require Logger

  alias Games.ThreeDragonAnte.GameConfig
  alias Games.ThreeDragonAnte
  alias GamesWeb.ThreeDragonAnteLive.GameConfigForm
  alias Phoenix.Naming

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <h1>Three Dragon Ante</h1>

      <.live_component
        module={GamesWeb.ThreeDragonAnteLive.GameConfigForm}
        id={:new}
        title="Setup your game"
        action={@live_action}
        game_config={@game_config}
        patch={~p"/games/three_dragon_ante"}
      />
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:game_config, GameConfig.new())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    log_info("Navigating to new game")

    push_patch(socket, to: ~p"/games/three_dragon_ante/new")
  end

  defp apply_action(socket, :new, _params) do
    socket
  end

  @impl true
  def handle_info({GameConfigForm, {:start, game_config}}, socket) do
    log_info("Setting up game.", config: game_config)

    {:ok, game} = ThreeDragonAnte.setup_game(game_config)
    log_info("Game ready!", game: game)

    {:noreply, push_navigate(socket, to: ~p"/games/three_dragon_ante/#{game.id}")}
  end

  defp log_info(message, context \\ []) do
    for {key, value} <- context, into: message do
      "\n  #{Naming.humanize(key)}: #{inspect(value, pretty: true)}"
    end
    |> Logger.info()
  end
end
