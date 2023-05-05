defmodule PairDanceWeb.LandingPageLive.Index do
  use PairDanceWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <h1>pair.dance</h1>
    <.live_component
    id={1}
    module={PairDanceWeb.AppLive.CreateTeamComponent}
    action={:new}
    />
    """
  end
end
