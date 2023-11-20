defmodule GamesWeb.ThreeDragonAnteLive.Show do
  use GamesWeb, :live_view

  alias Phoenix.Naming
  alias Games.ThreeDragonAnte
  alias Games.ThreeDragonAnte.{Card, Deck, Player}

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
    <.game_table>
      <h2>Join the game!</h2>
      <.player_list players={@game.players} />
      <.simple_form id="player-form" phx-submit="join" for={%{"name" => ""}}>
        <.input type="text" name="name" id="player-name-input" value="" />
        <:actions>
          <.button phx-disable-with="Joining...">Join Game</.button>
        </:actions>
      </.simple_form>
    </.game_table>
    """
  end

  def render(%{state: :can_start} = assigns) do
    ~H"""
    <.game_table>
      <h2>Start the game!</h2>
      <.player_list players={@game.players} />
      <.button phx-click="start">Start Game</.button>
    </.game_table>
    """
  end

  def render(assigns) do
    ~H"""
    <.game_table>
      <.deck deck={@game.deck} />
      <ul class="flex flex-col gap-2 p-2">
        <%= for player <- @game.players do %>
          <li><.player player={player} /></li>
        <% end %>
      </ul>
    </.game_table>
    """
  end

  slot :inner_block, required: true

  defp game_table(assigns) do
    ~H"""
    <div class="h-screen w-screen overflow-hidden bg-green-950 text-white">
      <%= render_slot(@inner_block) %>
    </div>
    """
  end

  attr :deck, Deck, required: true

  defp deck(assigns) do
    ~H"""
    <div class="p-2">
      <ul class={["flex flex-row border border-green-800 relative", card_class()]}>
        <%= for card <- @deck.cards do %>
          <li><.card card={card} class="absolute inset-0" /></li>
        <% end %>
      </ul>
      <p>Deck Size: <%= length(@deck.cards) %></p>
    </div>
    """
  end

  attr :card, Card, required: true
  attr :class, :string, default: ""

  defp card(%{card: %{type: :legendary_dragon}} = assigns) do
    ~H"""
    <div class={["bg-white text-black", @class, card_class()]}>
      <p><%= Naming.humanize(@card.name) %></p>
      <p><%= @card.power %></p>
    </div>
    """
  end

  defp card(%{card: %{type: :mortal}} = assigns) do
    ~H"""
    <div class={["bg-white text-black", @class, card_class()]}>
      <p>The <%= Naming.humanize(@card.name) %></p>
      <p><%= @card.power %></p>
    </div>
    """
  end

  defp card(%{card: %{type: :standard_dragon}} = assigns) do
    ~H"""
    <div class={["bg-white text-black", @class, card_class()]}>
      <p><%= Naming.humanize(@card.name) %></p>
      <p><%= @card.power %></p>
    </div>
    """
  end

  attr :player, Player, required: true

  defp player(assigns) do
    ~H"""
    <div class="flex flex-row gap-2">
      <div class={[
        "flex flex-col items-center justify-center bg-yellow-800",
        card_class()
      ]}>
        <%= @player.name %>
      </div>
      <ul class="flex flex-row gap-2">
        <%= for card <- @player.hand do %>
          <li><.card card={card} /></li>
        <% end %>
      </ul>
    </div>
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

  defp card_class, do: "w-[150px] h-[280px] p-2 rounded-sm"
end
