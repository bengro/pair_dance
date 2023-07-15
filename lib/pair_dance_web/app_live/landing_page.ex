defmodule PairDanceWeb.AppLive.LandingPage do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.WorkLog.EctoService, as: WorkLogService

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
          all_teams = TeamRepository.find_by_member(user.id)

          socket
          |> assign(:current_user, user)
          |> assign(:my_teams, all_teams)
          |> assign(:page_title, "Welcome")
      end

    {:ok, assigns}
  end
end
