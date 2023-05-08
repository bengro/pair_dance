defmodule PairDanceWeb.LandingPageLive.Index do
  use PairDanceWeb, :live_view
  import PairDanceWeb.Auth.AuthHelpers

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign_user(socket, session)}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <h1>pair.dance</h1>
    <img src={@user.avatar} referrerpolicy="no-referrer" />
    logged in as <%= @user.email %>
    <.live_component
    id={1}
    module={PairDanceWeb.AppLive.CreateTeamComponent}
    action={:new}
    />
    """
  end
end
