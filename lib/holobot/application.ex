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
      # Start Finch
      {Finch, name: HolofansAPIClient}
      # Start a worker by calling: Holobot.Worker.start_link(arg)
      # {Holobot.Worker, arg}
    ]

    Logger.info("Started the bot server", [])
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
    Nadia.set_webhook(
      url: Application.fetch_env!(:nadia, :webhook_base)
      # <> Application.fetch_env!(:nadia, :token)
    )
  end
end
