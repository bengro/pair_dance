defmodule PairDanceWeb.TeamLive.FormComponent do
  use PairDanceWeb, :live_component

  alias PairDance.Infrastructure.EctoTeamRepository, as: TeamRepository

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage team records in your database.</:subtitle>
      </.header>
      <.simple_form
        :let={f}
        for={:team}
        id="team-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :name}} type="text" label="name" value={@team.name} />
        <:actions>
          <.button phx-disable-with="Saving...">Save Team</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{team: team} = assigns, socket) do
    {:ok,
     socket
     |> assign(assigns)
    }
  end

  @impl true
  def handle_event("validate", %{"team" => team_params}, socket) do
    {:noreply, socket}
  end

  def handle_event("save", %{"team" => team_params}, socket) do
    save_team(socket, socket.assigns.action, team_params)
  end

  defp save_team(socket, :edit, team_params) do
    case TeamRepository.update(socket.assigns.team.id, team_params) do
      {:ok, _team} ->
        {:noreply,
         socket
         |> put_flash(:info, "Team updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}
    end
  end

  defp save_team(socket, :new, team_params) do
    case TeamRepository.create(team_params["name"]) do
      {:ok, _team} ->
        {:noreply,
         socket
         |> put_flash(:info, "Team created successfully")
         |> push_navigate(to: socket.assigns.navigate)}
    end
  end
end
