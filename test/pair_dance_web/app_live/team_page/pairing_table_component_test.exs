defmodule PairDanceWeb.AppLive.TeamPage.PairingTableComponentTest do
  use PairDance.UnitCase
  import Phoenix.LiveViewTest
  alias PairDanceWeb.AppLive.TeamPage.PairingTableComponent
  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Assignment
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.Team.Task
  alias PairDance.Domain.User

  test "renders work tracks" do
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

  test "renders assigned people" do
    task = %Task{id: 1, name: "my task"}
    member = %Member{ user: %User{ id: 1, email: "bob@gmail.com" }, role: :admin }
    team = %Team{
      id: "some-id",
      name: "my team",
      slug: "my-team",
      members: [member],
      assignments: [%Assignment{ task: task, member: member }],
      tasks: [task]
    }

    assert render_component(PairingTableComponent, id: 123, team: team) =~ "bob"
  end

  test "renders all unassigned members" do
    task = %Task{id: 1, name: "my task"}
    member = %Member{ user: %User{ id: 1, email: "bob@gmail.com" }, role: :admin }
    team = %Team{
      id: "some-id",
      name: "my team",
      slug: "my-team",
      members: [member],
      assignments: [],
      tasks: [task]
    }

    assert render_component(PairingTableComponent, id: 123, team: team) =~ "bob"
  end
end
