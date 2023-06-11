import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :pair_dance, PairDance.Infrastructure.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "pair_dance_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pair_dance, PairDanceWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "frW6rubBjFO/T6u3jNHuLnSJPwiop3QCnsVBT5qMlXaRJ8/yRaAXEtFaoBtonn0K",
  server: true

config :pair_dance, :sandbox, Ecto.Adapters.SQL.Sandbox

# In test we don't send emails.
config :pair_dance, PairDance.Mailer, adapter: Swoosh.Adapters.Test

# Disable swoosh api client as it is only required for production adapters.
config :swoosh, :api_client, false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# E2E configuration
config :wallaby,
  chromedriver: [
    headless: false
  ],
  otp_app: :pair_dance

# override SSO provider
IO.puts("Use fake auth provider")

config :ueberauth, Ueberauth,
  providers: [
    google: {PairDance.TestSupport.FakeGoogleAuth, []}
  ]
