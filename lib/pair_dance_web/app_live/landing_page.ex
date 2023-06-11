defmodule PairDanceWeb.AppLive.LandingPage do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  @impl true
  def mount(_params, session, socket) do
    user = session["current_user"]

    assigns =
      case user do
        nil ->
          socket
          |> assign(:current_user, user)
          |> assign(:page_title, "Welcome")

        _ ->
          socket
          |> assign(:current_user, user)
          |> assign(:my_teams, TeamRepository.find_by_member(user.id))
          |> assign(:page_title, "Welcome")
      end

    {:ok, assigns}
  end
end
