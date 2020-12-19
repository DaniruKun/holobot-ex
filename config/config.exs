# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :holobot, HolobotWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pPO4xRPOjXB5z5+b+/A7zynqOBY09O4pn31Yeo9410+kIb/DAg3DCjrsE4uDW2x+",
  render_errors: [view: HolobotWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Holobot.PubSub,
  live_view: [signing_salt: "m2Hg0E/s"],
  webhook_base: {:system, "WEBHOOK_URL_BASE", "https://localhost/"}

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Nadia Telegram bot API wrapper config
config :nadia,
  token: {:system, "TELEGRAM_TOKEN", "some_token"}

config :holofans,
  api_base_url: "https://api.holotools.app/v1"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
