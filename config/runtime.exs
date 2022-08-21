import Config

telegram_token =
  if Mix.env() != :test do
    System.get_env("TELEGRAM_TOKEN") ||
      raise """
      environment variable TELEGRAM_TOKEN is missing.
      """
  else
    ""
  end

config :holobot,
  http: [
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: telegram_token

# Nadia Telegram bot API wrapper config
config :nadia,
  token: telegram_token
