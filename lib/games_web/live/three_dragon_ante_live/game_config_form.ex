defmodule GamesWeb.ThreeDragonAnteLive.GameConfigForm do
  use GamesWeb, :live_component

  alias Games.ThreeDragonAnte

  @impl true
  def render(assigns) do
    ~H"""
    <div>
    <.header>
        <%= @title %>
      </.header>

      <.simple_form
        for={@form}
        id="game-config-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="start"
      >
        <:actions>
          <.button phx-disable-with="Starting...">Start Game</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{game_config: game_config} = assigns, socket) do
    changeset = ThreeDragonAnte.change_game_config(game_config)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    changeset =
      socket.assigns.game_config
      |> ThreeDragonAnte.change_game_config()
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  @impl true
  def handle_event("start", _params, socket) do
    case ThreeDragonAnte.create_game_config() do
      {:ok, game_config} ->
        notify_parent({:start, game_config})

        {:noreply,
         socket
         |> put_flash(:info, "Preparing your game")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> assign_form(changeset)
         |> put_flash(:error, "Not able to start your game")}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
