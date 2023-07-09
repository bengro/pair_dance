defmodule PairDanceWeb.Router do
  use PairDanceWeb, :router

  def ensure_authenticated(conn, _opts) do
    case get_session(conn, :current_user) do
      nil -> redirect(conn, to: "/") |> halt
      _ -> conn
    end
  end

  def ensure_team_member(conn, _opts) do
    user = get_session(conn, :current_user)
    %{"slug" => slug} = conn.params

    case PairDance.Domain.Team.AccessService.check_access(slug, user) do
      true -> conn
      false -> redirect(conn, to: "/") |> halt
    end
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug :ensure_authenticated
  end

  pipeline :app do
    plug :put_root_layout, {PairDanceWeb.Layouts, :app}
  end

  pipeline :team do
    plug :ensure_team_member
  end

  scope "/auth", PairDanceWeb do
    pipe_through :browser

    get "/", AuthController, :index
    get "/logout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  scope "/", PairDanceWeb do
    pipe_through [:browser, :app]

    live "/", AppLive.LandingPage, :landing_page

    scope "/!" do
      pipe_through [:auth]
      live "/account", AppLive.AccountPage, :index
    end

    scope "/:slug" do
      pipe_through [:auth, :team]
      live "/", AppLive.TeamPage, :index
    end
  end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:pair_dance, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: PairDanceWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
