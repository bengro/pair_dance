defmodule PairDanceWeb.AppLive.MemberComponent do
  use PairDanceWeb, :live_component

  def update(assigns, socket) do
    {:ok, assign(socket, assigns)}
  end
end
