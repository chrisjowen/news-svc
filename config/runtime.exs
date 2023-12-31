import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# Start the phoenix server if environment is set and running in a release
if System.get_env("PHX_SERVER") && System.get_env("RELEASE_NAME") do
  config :news_service, NewsService.Web.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """


  # maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  # Not sure why
  # config :news_service, NewsService.Repo,
  #   # ssl: true,
  #   url: database_url,
  #   pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
  #   socket_options: maybe_ipv6

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :ueberauth, Ueberauth.Strategy.Facebook.OAuth,
    client_id: "773947543964189",
    client_secret: "afaac670206d02cbc2ddfaaec0f8fb8b"


  config :news_service, NewsService.Repo,
    url: database_url,
    types: NewsService.PostgresTypes

  host = System.get_env("PHX_HOST") || "www.reddotz.com"
  port = String.to_integer(System.get_env("PORT") || "4000")

  config :news_service, NewsService.Web.Endpoint,
    url: [host: host, port: 4000],
    http: [
      ip: {0, 0, 0, 0, 0, 0, 0, 0},
      port: port
    ],
    secret_key_base: secret_key_base


  # ## Using releases
  #
  # If you are doing OTP releases, you need to instruct Phoenix
  # to start each relevant endpoint:
  #
  #     config :news_service, NewsService.Web.Endpoint, server: true
  #
  # Then you can assemble a release by calling `mix release`.
  # See `mix help release` for more information.

end
