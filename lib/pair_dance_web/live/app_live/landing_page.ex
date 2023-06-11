defmodule PairDanceWeb.LandingPageLive.Index do
  use PairDanceWeb, :live_view

  @impl true
  def mount(_params, session, socket) do
    {:ok, assign(socket, :current_user, session["current_user"])}
  end

  @impl Phoenix.LiveView
  def render(assigns) do
    ~H"""
    <h1 class="text-3xl font-bold">pair.dance</h1>

    <%= if @current_user do %>
      <h2>Hi, <%= @current_user.name %>!</h2>
    <% else %>
      <p>
        You're not logged in. Check out the amazing pair.dance features and
        <.link href={~p"/auth"} class="button">login</.link>
      </p>
    <% end %>
    """
  end
end
