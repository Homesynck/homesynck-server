defmodule HomesynckWeb.Router do
  use HomesynckWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {HomesynckWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    #plug NavigationHistory.Tracker, accept_duplicates: false
    plug HomesynckWeb.AuthPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", HomesynckWeb do
    pipe_through :browser

    get "/", PageController, :index
    get "/login", SessionController, :new
    get "/logout", SessionController, :delete
    get "/dashboard", PageController, :dashboard

    resources "/sessions", SessionController, only: [:new, :create, :delete], singleton: true
    # live "/", PageLive, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", HomesynckWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: HomesynckWeb.Telemetry
    end
  end
end
