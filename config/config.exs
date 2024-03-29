# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :holobot,
  http: [port: {:system, "PORT"}],
  bot_name: "a_chan_bot",
  holofans_api: "https://api.holotools.app/"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :mnesia,
  dir: '.mnesia/#{Mix.env()}/#{node()}'

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
