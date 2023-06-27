import Config

# Configure your database
config :news_service, NewsService.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "news_service_dev",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10,
  port: 5534,
  types: NewsService.PostgresTypes



config :news_service, NewsService.Web.Endpoint,
  # Binding to loopback ipv4 address prevents access from other machines.
  # Change to `ip: {0, 0, 0, 0}` to allow access from other machines.
  http: [ip: {127, 0, 0, 1}, port: 4001],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "VU3A3GKLNuJdZloBqduRcisaKAKlgN5Pq2XGt9OgU2kKwQ75aW1GkPYaFKs86O9j",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
  ]

config :logger, :console, format: "[$level] $message\n"
config :logger, level: :info
config :phoenix, :stacktrace_depth, 20
config :phoenix, :plug_init_mode, :runtime
