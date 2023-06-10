defmodule PairDanceWeb.AuthController do
  use PairDanceWeb, :controller
  plug Ueberauth

  require Logger

  alias Ueberauth.Auth

  @redirect_url "/auth"

  def index(conn, _params) do
    render(conn, :index, current_user: get_session(conn, :current_user))
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "You have been logged out!")
    |> clear_session()
    |> redirect(to: @redirect_url)
  end

  def callback(
        %{
          assigns: %{
            ueberauth_failure: _fails
          }
        } = conn,
        _params
      ) do
    conn
    |> put_flash(:error, "Failed to authenticate.")
    |> redirect(to: @redirect_url)
  end

  def callback(
        %{
          assigns: %{
            ueberauth_auth: auth
          }
        } = conn,
        _params
      ) do
    case extract_user(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Successfully authenticated.")
        |> put_session(:current_user, user)
        |> configure_session(renew: true)
        |> redirect(to: @redirect_url)

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: @redirect_url)
    end
  end

  # We need to define the request call back to enable E2E tests.
  if Mix.env() == :test do
    def request(conn, params) do
      callback(conn, params)
    end
  end

  defp extract_user(%Auth{provider: :google} = auth) do
    case auth.info do
      nil ->
        {:error, "Login failed"}

      _ ->
      user = PairDance.Domain.User.LoginService.login(auth.info.email, auth.info.name, auth.info.image)
      {:ok, user}
    end
  end
end
