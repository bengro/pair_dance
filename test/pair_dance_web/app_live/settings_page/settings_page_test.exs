defmodule PairDanceWeb.AppLive.SettingsPageTest do
  use PairDanceWeb.ConnCase

  import Phoenix.LiveViewTest
  import PairDance.TeamsFixtures

  alias PairDance.Domain.Team.TeamService

  defp setup_data(_) do
    user = user_fixture()
    {:ok, team} = TeamService.new_team("my team", user)
    task_fixture(team, "Refactor something amazing")
    task_fixture(team, "Implement FedRamp-compliant cache")

    team = PairDance.Infrastructure.Team.EctoRepository.find(team.descriptor.id)

    %{team: team, user: user}
  end

  setup [:setup_data]

  test "invite a new member", %{conn: conn, team: team, user: user} do
    {:ok, view, _} =
      conn
      |> impersonate(user)
      |> live(~p"/#{team.descriptor.slug}/settings")

    view
    |> form("#add-member-form", user: %{email: "new-member@gmail.com"})
    |> render_submit()

    assert render(view) =~ "new-member@gmail.com"
  end
end
