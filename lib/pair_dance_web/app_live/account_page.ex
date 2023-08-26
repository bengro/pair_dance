defmodule PairDanceWeb.AppLive.AccountPage do
  use PairDanceWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    user = session["current_user"]

    assigns =
      assign_user(socket, session)
      |> assign(:page_title, "Your Account")
      |> assign(:current_user, user)

    {:ok, assigns}
  end

  defp assign_user(socket, session) do
    user = session["current_user"]
    Phoenix.Component.assign(socket, :user, user)
  end
end
