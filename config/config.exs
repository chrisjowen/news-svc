# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :news_service,
  ecto_repos: [NewsService.Repo]

config :cors_plug,
  origin: [
    "https://news.crowdsolve.ai/",
    "http://127.0.0.1:5173",
    "http://localhost:4000",
    "http://localhost:4001"
  ],
  max_age: 86400,
  methods: ["GET", "POST", "DELETE", "PUT", "OPTIONS", "HEAD"]

# Configures the endpoint
config :news_service, NewsService.Web.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: NewsService.Web.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: NewsService.PubSub,
  live_view: [signing_salt: "gSpMyCEo"]

config :news_service, Oban,
  repo: NewsService.Repo,
  queues: [default: 3, scheduler: 1, medium: 1, youtube: 3, newsapi: 3, medium_article: 5],
  plugins: [
    Oban.Plugins.Pruner,
    # {Oban.Plugins.Cron,
    #  crontab: [
    #    {"* * * * *", NewsService.Workers.ScheduledWorker},
    #  ]}
  ]

config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :geo_postgis,
  json_library: Jason

config :openai,
  api_key: System.get_env("OPEN_AI_KEY"),
  organization_key: "org-2cJ3cEThmAglpQRKQr3X2W64",
  http_options: [recv_timeout: 120_000]

import_config "#{config_env()}.exs"
