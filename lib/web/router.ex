defmodule NewsService.Web.Router do
  use NewsService.Web, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  scope "/api", NewsService do
    pipe_through(:api)
    # Unsecured

    resources "/feed", FeedItemController
    resources "/schedule", FeedScheduleController
    post "/schedule/run", FeedScheduleController, :run_schedules
  end

  # Enables LiveDashboard only for development
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through([:fetch_session, :protect_from_forgery])
      live_dashboard("/dashboard", metrics: NewsService.Web.Telemetry)
    end
  end

end
