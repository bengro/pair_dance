defmodule PairDanceWeb.AppLive.AccountPage do
  use PairDanceWeb, :live_view
  import PairDanceWeb.Auth.AuthHelpers

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_user(socket, session)}
  end
end
