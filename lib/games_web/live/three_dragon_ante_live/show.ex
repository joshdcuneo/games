defmodule GamesWeb.ThreeDragonAnteLive.Show do
  alias Games.ThreeDragonAnte
  alias Games.ThreeDragonAnte.{Card, Deck, Player}
  use GamesWeb, :live_view

  @impl true
  def mount(params, _session, socket) do
    {:ok, load_game(socket, params["game_id"])}
  end

  defp load_game(socket, game_id) do
    {:ok, game_state} = ThreeDragonAnte.connect_to_game(game_id)

    assign_game_state(socket, game_state)
  end

  @impl true
  def handle_event("join", %{"name" => name}, socket) when is_binary(name) do
    player = %Player{name: name}
    {:ok, game_state} = ThreeDragonAnte.join_game(socket.assigns.game, player)

    {:noreply, assign_game_state(socket, game_state)}
  end

  @impl true
  def handle_event("start", _params, socket) do
    {:ok, game_state} = ThreeDragonAnte.start_game(socket.assigns.game)

    {:noreply, assign_game_state(socket, game_state)}
  end

  defp assign_game_state(socket, game_state) do
    socket
    |> assign(:state, game_state.type)
    |> assign(:game, game_state.game)
  end

  @impl true
  def render(%{state: :waiting_for_players, game: _} = assigns) do
    ~H"""
    <div>
      <h2>Join the game!</h2>
      <.player_list players={@game.players} />
      <.simple_form id="player-form" phx-submit="join" for={%{"name" => ""}}>
        <.input type="text" name="name" id="player-name-input" value="" />
        <:actions>
          <.button phx-disable-with="Joining...">Join Game</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def render(%{state: :can_start} = assigns) do
    ~H"""
    <div>
      <h2>Start the game!</h2>
      <.player_list players={@game.players} />
      <.button phx-click="start">Start Game</.button>
    </div>
    """
  end

  def render(assigns) do
    IO.inspect(assigns)

    ~H"""
    <.game_table>
      <.deck deck={@game.deck} />
      <%= for player <- @game.players do %>
        <.player player={player} />
      <% end %>
    </.game_table>
    """
  end

  slot :inner_block, required: true

  defp game_table(assigns) do
    ~H"""
    <div class="h-screen w-screen bg-green-950">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :deck, Deck, required: true

  defp deck(assigns) do
    ~H"""
    <div class="flex flex-row border border-green-800 relative w-[100px] h-[200px]">
      <%= for card <- @deck.cards do %>
        <.card card={card} />
      <% end %>
    </div>
    """
  end

  attr :card, Card, required: true

  defp card(assigns) do
    ~H"""
    <div class="w-[100px] h-[200px] bg-blue-800 absolute inset-0" />
    """
  end

  attr :player, Player, required: true

  defp player(assigns) do
    ~H"""
    <div class="flex flex-col bg-yellow-800 w-[100px] h-[100px]" />
    """
  end

  attr :players, :list, required: true

  defp player_list(assigns) do
    ~H"""
    <ul>
      <%= for player <- @players do %>
        <li><%= player.name %></li>
      <% end %>
    </ul>
    """
  end
end
