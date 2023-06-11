defmodule PairDance.E2E.Tests do
  use ExUnit.Case, async: true
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

  feature "view the dashboard", %{session: session} do
    Application.put_env(:wallaby, :base_url, PairDanceWeb.Endpoint.url())

    session
    |> visit("/auth")
    |> click(Query.text("Login"))
    |> assert_text("Hi, Joe Dough!")
  end
end
