# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

# Configures the endpoint
config :holobot, HolobotWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pPO4xRPOjXB5z5+b+/A7zynqOBY09O4pn31Yeo9410+kIb/DAg3DCjrsE4uDW2x+",
  render_errors: [view: HolobotWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Holobot.PubSub,
  live_view: [signing_salt: "m2Hg0E/s"]

config :holobot,
  bot_name: "a_chan_bot",
  holofans_api: "https://api.holotools.app/"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Nadia Telegram bot API wrapper config
config :nadia,
  token: {:system, "TELEGRAM_TOKEN", "some_token"}

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
