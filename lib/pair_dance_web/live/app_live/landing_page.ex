defmodule PairDanceWeb.LandingPageLive.Index do
  use PairDanceWeb, :live_view

  @impl true
  def mount(_params, _, socket) do
    {:ok, socket}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <h1 class="text-3xl font-bold">pair.dance</h1>
    Landing page <.live_component id="1" module={PairDanceWeb.ShoppingListComponent} />
    """
  end
end
