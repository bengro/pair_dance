defmodule PairDance.E2E.Tests do
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

  feature "on-boarding journey", %{session: session} do
    Application.put_env(:wallaby, :base_url, PairDanceWeb.Endpoint.url())

    session
    |> visit("/")
    |> click(Query.text("Login"))
    |> assert_text("Hi, Joe Dough")
    |> fill_in(Query.css("#new-team-form_name"), with: "Comet")
    |> click(data_qa("new-team-submit"))
    |> fill_in(Query.css("#new-task-form_name"), with: "Refactor the code")
    |> click(data_qa("new-task-submit"))
    |> assert_has(data_qa("pairing-table"))
    |> assert_has(data_qa("member-avatar"))

    {x, y} =
      find(session, data_qa("workstream"))
      |> Element.location()

    session
    |> touch_down(data_qa("member-avatar"))
    |> touch_move(x, y)
    |> touch_up()
    |> assert_has(Query.css("[data-qa=workstream] [data-qa=member-avatar]"))
  end
end
