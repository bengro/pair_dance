defmodule PairDanceWeb.TeamLive.Index do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.EctoTeamRepository, as: TeamRepository

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :teams, TeamRepository.find_all())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Team")
    |> assign(:team, TeamRepository.find(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Team")
    |> assign(:team, nil)
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Teams")
    |> assign(:team, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    {:ok} = TeamRepository.delete(id)

    {:noreply, assign(socket, :teams, TeamRepository.find_all())}
  end
end
