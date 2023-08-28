defmodule PairDanceWeb.AppLive.LandingPage do
  use PairDanceWeb, :live_view

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository
  alias PairDance.Infrastructure.User.EctoRepository, as: UserRepository

  @impl true
  def mount(_params, session, socket) do
    session_user = session["current_user"]

    assigns =
      case session_user do
        nil ->
          socket
          |> assign(:page_title, "Welcome")
          |> assign(:current_user, session_user)

        _ ->
          user = UserRepository.find_by_id(session_user.id)

          if user.last_active_team_id != nil do
            last_team = TeamRepository.find(user.last_active_team_id)
            push_navigate(socket, to: "/" <> last_team.descriptor.slug)
          else
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
      end

    {:ok, assigns}
  end
end
