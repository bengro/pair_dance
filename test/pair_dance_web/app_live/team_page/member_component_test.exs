defmodule PairDanceWeb.AppLive.TeamPage.MemberComponentTest do
  use PairDance.UnitCase
  import Phoenix.LiveViewTest

  alias PairDanceWeb.AppLive.TeamPage.MemberComponent
  alias PairDance.Domain.Team.Member
  alias PairDance.Domain.User

  test "renders name and avatar when available" do
    user = %User{
      id: 1,
      email: "jane@doe.com",
      avatar: "https://avatar.com",
      name: "Jane Doe"
    }

    member = %Member{user: user, role: :admin}

    html = render_component(MemberComponent, member: member)

    assert html =~ "Jane Doe"
    assert html =~ "https://avatar.com"
    refute html =~ "jane@doe.com"
  end

  test "renders just the email when name and avatar not available" do
    user = %User{
      id: 1,
      email: "jane@doe.com"
    }

    member = %Member{user: user, role: :admin}

    html = render_component(MemberComponent, member: member)

    assert html =~ "jane@doe.com"
  end
end
