defmodule Holobot.Application do
  @moduledoc false
  require Logger
  require Nadia

  use Application

  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      HolobotWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Holobot.PubSub},
      # Start the Endpoint (http/https)
      HolobotWeb.Endpoint,
      # Start Finch HTTP client for fetching data from Holofans API
      {Finch, name: HolofansAPIClient}
      # Start a worker by calling: Holobot.Worker.start_link(arg)
      # {Holobot.Worker, arg}
    ]
    setup_telegram()
    #:ok = setup_telegram()
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Holobot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HolobotWeb.Endpoint.config_change(changed, removed)
    :ok
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
