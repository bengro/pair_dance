defmodule PairDanceWeb.AppLive.AccountPage do
  use PairDanceWeb, :live_view
  import PairDanceWeb.Auth.AuthHelpers

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  @impl true
  def mount(_params, session, socket) do
    user = session["current_user"]
    all_teams = TeamRepository.find_by_member(user.id)

    assigns =
      assign_user(socket, session)
      |> assign(:page_title, "Your Account")
      |> assign(:all_teams, all_teams)
      |> assign(:current_user, user)

    {:ok, assigns}
  end
end
