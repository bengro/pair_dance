defmodule PairDance.E2E.Tests do
  use ExUnit.Case, async: true
  use Wallaby.Feature

  @moduletag :e2e

  setup_all do
    Application.ensure_all_started(:wallaby)
    :ok
  end

  feature "view the dashboard", %{session: session} do
    Application.put_env(:wallaby, :base_url, PairDanceWeb.Endpoint.url())

    session
    |> visit("/auth")
    |> click(Query.text("Login"))
    |> assert_text("Hi, Joe Dough!")
  end
end
