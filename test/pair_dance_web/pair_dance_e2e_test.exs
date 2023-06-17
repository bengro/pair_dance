defmodule PairDance.E2E.Tests do
  use ExUnit.Case, async: false
  use Wallaby.Feature

  setup_all do
    Application.ensure_all_started(:wallaby)
    :ok
  end

  setup %{session: session} do
    on_exit(fn ->
      Wallaby.end_session(session)
    end)
  end

  feature "onboarding journey", %{session: session} do
    Application.put_env(:wallaby, :base_url, PairDanceWeb.Endpoint.url())

    session
    |> visit("/auth")
    |> click(Query.text("Login"))
    |> assert_text("Hi, Joe Dough!")

    |> visit("/!/account")
    |> fill_in(Query.css("#new-team-form_name"), with: "Comet")
    |> click(Query.text("Create"))

    |> fill_in(Query.css("#new-task-form_name"), with: "Refactor the code")
    |> click(Query.text("Save Task"))
    |> assert_has(Query.css("[data-qa=pairing-table]"))
  end
end
