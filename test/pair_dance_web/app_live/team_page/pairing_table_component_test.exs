defmodule PairDanceWeb.AppLive.TeamPage.PairingTableComponentTest do
  use PairDance.UnitCase
  import Phoenix.LiveViewTest
  alias PairDanceWeb.AppLive.TeamPage.PairingTableComponent
  alias PairDance.Domain.Team
  alias PairDance.Domain.Team.Assignment
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.Team.Task
  alias PairDance.Domain.Team.TimeRange
  alias PairDance.Domain.User
  alias Floki

  def aDescriptor() do
    %Team.Descriptor{
      id: "some-id",
      name: "my team",
      slug: "my-team"
    }
  end

  test "renders work tracks" do
    team = %Team{
      descriptor: aDescriptor(),
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
      descriptor: aDescriptor(),
      members: [member],
      assignments: [
        %Assignment{
          task: task1,
          member: member,
          time_range: %TimeRange{start: DateTime.utc_now(), end: nil}
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

  test "renders all available and unassigned members" do
    task = %Task{id: 1, name: "my task"}

    available_member = %Member{
      user: %User{id: 1, email: "bob@gmail.com"},
      role: :admin,
      available: true
    }

    unavailable_member = %Member{
      user: %User{id: 2, email: "alice@gmail.com"},
      role: :admin,
      available: false
    }

    team = %Team{
      descriptor: aDescriptor(),
      members: [available_member, unavailable_member],
      assignments: [],
      tasks: [task]
    }

    html = render_component(PairingTableComponent, id: 123, team: team)
    {:ok, document} = Floki.parse_document(html)

    assert document |> Floki.find("[data-qa=available-members]") |> Floki.text() =~ "bob"
    refute document |> Floki.find("[data-qa=available-members]") |> Floki.text() =~ "alice"
  end

  test "renders all unavailable members" do
    task = %Task{id: 1, name: "my task"}

    available_member = %Member{
      user: %User{id: 1, email: "bob@gmail.com"},
      role: :admin,
      available: true
    }

    unavailable_member = %Member{
      user: %User{id: 2, email: "alice@gmail.com"},
      role: :admin,
      available: false
    }

    team = %Team{
      descriptor: aDescriptor(),
      members: [available_member, unavailable_member],
      assignments: [],
      tasks: [task]
    }

    html = render_component(PairingTableComponent, id: 123, team: team)
    {:ok, document} = Floki.parse_document(html)

    refute document |> Floki.find("[data-qa=unavailable-members]") |> Floki.text() =~ "bob"
    assert document |> Floki.find("[data-qa=unavailable-members]") |> Floki.text() =~ "alice"
  end
end
