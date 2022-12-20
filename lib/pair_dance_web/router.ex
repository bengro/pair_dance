defmodule PairDanceWeb.Router do
  use PairDanceWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {PairDanceWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PairDanceWeb do
    pipe_through :browser

    get "/", PageController, :index

    # team management
    live "/teams", TeamLive.Index, :index
    live "/teams/new", TeamLive.Index, :new
    live "/teams/:id/edit", TeamLive.Index, :edit

    live "/teams/:id", TeamLive.Show, :show
    live "/teams/:id/show/edit", TeamLive.Show, :edit

    # member management
    live "/members", MemberLive.Index, :index
    live "/members/new", MemberLive.Index, :new
    live "/members/:id/edit", MemberLive.Index, :edit

    live "/members/:id", MemberLive.Show, :show
    live "/members/:id/show/edit", MemberLive.Show, :edit

    # task management
    live "/tasks", TaskLive.Index, :index
    live "/tasks/new", TaskLive.Index, :new
    live "/tasks/:id/edit", TaskLive.Index, :edit

    live "/tasks/:id", TaskLive.Show, :show
    live "/tasks/:id/show/edit", TaskLive.Show, :edit
  end

  scope "/auth", PairDanceWeb do
    pipe_through :browser

    get "/", AuthController, :index
    get "/logout", AuthController, :delete
    get "/:provider", AuthController, :request
    get "/:provider/callback", AuthController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", PairDanceWeb do
  #   pipe_through :api
  # end

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
