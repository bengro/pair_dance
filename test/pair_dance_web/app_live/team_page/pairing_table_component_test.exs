defmodule PairDanceWeb.AppLive.TeamPage.PairingTableComponentTest do
  use PairDance.UnitCase
  import Phoenix.LiveViewTest
  alias PairDanceWeb.AppLive.TeamPage.PairingTableComponent
  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Assignment
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.Team.Task
  alias PairDance.Domain.User
  alias Floki

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

  test "renders assigned people in the correct workstream" do
    task1 = %Task{id: 1, name: "my task"}
    task2 = %Task{id: 2, name: "another task"}
    member = %Member{user: %User{id: 1, email: "bob@gmail.com"}, role: :admin}

    team = %Team{
      id: "some-id",
      name: "my team",
      slug: "my-team",
      members: [member],
      assignments: [
        %Assignment{
          task: task1,
          member: member,
          assigned_at: DateTime.utc_now(),
          unassigned_at: nil
        }
      ],
      tasks: [task1, task2]
    }

    html = render_component(PairingTableComponent, id: 123, team: team)
    {:ok, document} = Floki.parse_document(html)

    assert document
           |> Floki.find("[data-qa=workstream]")
           |> Enum.filter(fn el -> Floki.text(el) =~ "my task" end)
           |> Floki.text() =~ "bob"

    refute document
           |> Floki.find("[data-qa=workstream]")
           |> Enum.filter(fn el -> Floki.text(el) =~ "another task" end)
           |> Floki.text() =~ "bob"

    refute document |> Floki.find("[data-qa=available-members]") |> Floki.text() =~ "bob"
  end

  test "renders all unassigned members" do
    task = %Task{id: 1, name: "my task"}
    member = %Member{user: %User{id: 1, email: "bob@gmail.com"}, role: :admin}

    team = %Team{
      id: "some-id",
      name: "my team",
      slug: "my-team",
      members: [member],
      assignments: [],
      tasks: [task]
    }

    html = render_component(PairingTableComponent, id: 123, team: team)
    {:ok, document} = Floki.parse_document(html)

    assert document |> Floki.find("[data-qa=available-members]") |> Floki.text() =~ "bob"
  end
end
