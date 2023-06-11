defmodule PairDanceWeb.AppLive.LandingPage do
  use PairDanceWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    assigns =
      socket
      |> assign(:current_user, session["current_user"])
      |> assign(:page_title, "Welcome")

    {:ok, assigns}
  end
end
