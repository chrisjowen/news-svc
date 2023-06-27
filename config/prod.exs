import Config


config :news_service, NewsService.Web.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

config :logger, level: :debug
