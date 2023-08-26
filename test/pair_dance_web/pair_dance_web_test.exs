defmodule PairDanceWebTest do
  use PairDance.E2eCase

  setup_all do
    Application.ensure_all_started(:wallaby)
    :ok
  end

  setup %{session: session} do
    on_exit(fn ->
      Wallaby.end_session(session)
    end)
  end

  feature "pair.dance journey", %{session: session} do
    Application.put_env(:wallaby, :base_url, PairDanceWeb.Endpoint.url())

    # sign up and log in
    session
    |> visit("/")
    |> click(Query.text("Login with Google"))
    |> assert_text("Hi, Joe Dough")

    # create a team
    session
    |> click(Query.text("Create Team"))
    |> assert_text("Team name")
    |> fill_in(Query.css("#new-team-form_name"), with: "Comet")
    |> click(data_qa("new-team-submit"))
    |> assert_text("Comet")

    # create task
    session
    |> visit("/comet")
    |> fill_in(Query.css("#new-task-form_name"), with: "Refactor the code")
    |> click(data_qa("new-task-submit"))
    |> assert_text("Refactor the code")
    |> assert_text("JD")

    # log out
    session
    |> visit("/")
    |> click(Query.text("Hi, Joe Dough"))
    |> click(Query.text("Log out"))

    # redirect to team page directly after login
    session
    |> visit("/comet")
    |> click(Query.text("Login with Google"))
    |> assert_text("Hi, Joe Dough")

    # change team settings, invite team members
    session
    |> click(Query.text("Team Settings"))
    |> assert_text("joe@dough.com")
    |> fill_in(Query.css("#add-member-form_email"), with: "alice@wonderland.com")
    |> click(data_qa("add-member-submit"))
    |> assert_text("alice@wonderland.com")

    # use insights
    session
    |> visit("/comet")
    |> click(Query.text("Insights"))
    |> assert_text("Your activity")

    # delete the team
    session
    |> visit("/comet")
    |> click(Query.text("Settings"))
    |> click(Query.text("Delete Team"))
    |> assert_text("Danger Zone")
    |> click(Query.text("I want to permanently delete Team Comet"))
    |> assert_text("Welcome")

    # pair rotations - drag & drop is difficult to simulate :/

    # OPTION 1: Does not work; browser doesn't do anything visibly
    #    session
    #    |> visit("/comet")
    #
    #    a_avatar = Query.css("[data-qa=member-avatar]", at: 0, count: 2)
    #    member_avatar = find(session, a_avatar)
    #
    #    {x, y} =
    #      member_avatar
    #      |> Element.location()
    #
    #    session
    #    |> touch_down(a_avatar)
    #    |> Wallaby.Browser.button_down()
    #    |> touch_move(x - 200, y)
    #    |> touch_up()
    #    |> assert_has(Query.css("#task-0 [data-qa=member-avatar]"))

    # OPTION 2: Does not work; browser doesn't do anything visibly
    #    session
    #    |> visit("/comet")
    #
    #    Use move_mouse_by
    #    {x, y} =
    #      find(session, Query.css("[data-qa=member-avatar]", at: 0, count: 2))
    #      |> Element.location()
    #
    #    session
    #    |> Wallaby.Browser.move_mouse_by(x, y)
    #    |> Wallaby.Browser.button_down(:middle)
    #    |> Wallaby.Browser.move_mouse_by(-400, 0)
    #    |> Wallaby.Browser.button_up()
    #    |> assert_has(Query.css("#task-0 [data-qa=member-avatar]"))
  end
end
