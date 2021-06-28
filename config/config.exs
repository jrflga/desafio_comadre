# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :comadre_pay,
  ecto_repos: [ComadrePay.Repo],
  generators: [binary_id: true]

config :comadrepay, ComadrePay.Repo,
  migration_primary_key: [type: :binary_id],
  migration_foreign_key: [type: :binary_id]

config :comadrepay, :basic_auth,
  username: "df221400-0fe1-4567-a7fb-35498d651fb9",
  password: "a3905135-2c9b-4e89-a6b3-354691665463"

# Configures the endpoint
config :comadre_pay, ComadrePayWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Z3yFAJBpo16JtRV1AdwOAA7hVz2+7/a+VIXaqlFtzgNg6Ibdrc/zDPygHDDT8pRh",
  render_errors: [view: ComadrePayWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: ComadrePay.PubSub,
  live_view: [signing_salt: "sAeshpj5"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
