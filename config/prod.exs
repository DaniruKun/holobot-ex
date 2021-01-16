use Mix.Config

# Do not print debug messages in production
config :logger, level: :info

System.get_env("TELEGRAM_TOKEN") ||
  raise """
  Environment variable TELEGRAM_TOKEN not set.
  """

import_config "prod.secret.exs"
