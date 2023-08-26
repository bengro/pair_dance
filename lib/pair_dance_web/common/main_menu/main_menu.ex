defmodule PairDanceWeb.Common.MainMenu do
  use PairDanceWeb, :live_component

  alias PairDance.Infrastructure.Team.EctoRepository, as: TeamRepository

  @impl true
  def update(assigns, socket) do
    user = assigns.current_user
    all_teams = TeamRepository.find_by_member(user.id)

    assigns =
      socket
      |> assign(:current_user, user)
      |> assign(:all_teams, all_teams)

    {:ok, assigns}
  end
end
