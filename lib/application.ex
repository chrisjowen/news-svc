defmodule NewsService.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      NewsService.Repo,
      NewsService.Web.Telemetry,
      {Phoenix.PubSub, name: NewsService.PubSub},
      NewsService.Web.Endpoint,
      {Oban, Application.fetch_env!(:news_service, Oban)}
    ]

    opts = [strategy: :one_for_one, name: NewsService.Supervisor]
    events = [[:oban, :job, :start], [:oban, :job, :stop], [:oban, :job, :exception]]

    :telemetry.attach_many("oban-logger", events, &NewsService.ObanLogger.handle_event/4, [])
    Oban.Telemetry.attach_default_logger()
    # Oban.resume_queue
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    NewsService.Web.Endpoint.config_change(changed, removed)
    :ok
  end
end
