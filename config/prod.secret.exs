# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
import Config

telegram_token =
  System.get_env("TELEGRAM_TOKEN") ||
    raise """
    environment variable TELEGRAM_TOKEN is missing.
    """

config :holobot,
  http: [
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: telegram_token
