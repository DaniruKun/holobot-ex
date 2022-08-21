defmodule Holobot.MixProject do
  use Mix.Project

  def project do
    [
      app: :holobot,
      version: "0.1.0",
      elixir: "~> 1.7",
      default_task: "server",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      build_embedded: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {Holobot.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:telemetry_metrics, "~> 0.4"},
      {:telemetry_poller, "~> 0.4"},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:nadia, "~> 0.7.0"},
      {:mock, "~> 0.3.6", only: [:dev, :test]},
      {:httpoison, "~> 1.8", override: true},
      {:telemetry, "~> 0.4", override: true},
      {:memento, "~> 0.3.1"},
      {:holodex, "~> 0.1.3"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 0.4", only: [:dev]}
    ]
  end

  defp aliases do
    [
      setup: ["deps.get"],
      lint: ["credo"],
      server: ["run --no-halt"]
    ]
  end
end
