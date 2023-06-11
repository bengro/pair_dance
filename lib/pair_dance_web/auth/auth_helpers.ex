defmodule PairDanceWeb.Auth.AuthHelpers do
  def assign_user(socket, session) do
    user = session["current_user"]
    Phoenix.Component.assign(socket, :user, user)
  end
end
