# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
use Mix.Config

telegram_token =
  System.get_env("TELEGRAM_TOKEN") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    """

config :holobot,
  http: [
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: telegram_token

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
#     config :holobot, HolobotWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
