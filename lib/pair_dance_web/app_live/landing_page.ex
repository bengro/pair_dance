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
          all_teams = TeamRepository.find_by_member(user.id)

          if length(all_teams) == 0 do
            socket
            |> assign(:current_user, user)
            |> assign(:page_title, "Create Team")
          else
            team_descriptor = Enum.at(all_teams, 0)
            push_navigate(socket, to: "/" <> team_descriptor.slug)
          end
      end

    {:ok, assigns}
  end
end
