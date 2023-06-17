defmodule PairDanceWeb.AppLive.TeamPage.PairingTableComponentTest do
  use PairDance.UnitCase
  import Phoenix.LiveViewTest
  alias PairDanceWeb.AppLive.TeamPage.PairingTableComponent
  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Task

  test "renders tasks" do
    team = %Team{
      id: "some-id",
      name: "my team",
      slug: "my-team",
      members: [],
      assignments: [],
      tasks: [%Task{id: 1, name: "my task"}]
    }

    assert render_component(PairingTableComponent, id: 123, team: team) =~ "my task"
  end
end
