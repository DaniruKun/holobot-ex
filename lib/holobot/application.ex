defmodule Holobot.Application do
  @moduledoc false
  require Logger
  require Nadia

  use Application

  def start(_type, _args) do
    bot_name = Application.get_env(:holobot, :bot_name)

    unless String.valid?(bot_name) do
      IO.warn("""
      Env not found Application.get_env(:holobot, :bot_name)
      This will give issues when generating commands
      """)
    end

    if bot_name == "" do
      IO.warn("An empty bot_name env will make '/anycommand@' valid")
    end

    children = [
      # Start Finch HTTP client for fetching data from Holofans API
      {Finch, name: HolofansAPIClient},
      # Start Telegram API poller
      {Holobot.Telegram.Poller, []},
      # Start matcher
      {Holobot.Telegram.Matcher, []}
    ]

    opts = [strategy: :one_for_one, name: Holobot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp setup_telegram() do
    webhook_url = Application.fetch_env!(:holobot, :webhook_url)

    Logger.debug("Setting Telegram API webhook URL to: #{webhook_url}")

    Nadia.set_webhook(
      url: webhook_url,
      ip_address: URI.parse(webhook_url).host
      # <> Application.fetch_env!(:nadia, :token)
    )
  end
end
