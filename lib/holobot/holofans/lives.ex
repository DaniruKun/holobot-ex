defmodule Holobot.Holofans.Lives do
  @moduledoc """
  Holofans API lives context.
  """

  require Logger
  require Finch
  require Jason

  @holofans_api_base Application.fetch_env!(:holobot, :holofans_api)

  @doc """
  Get currently live, upcoming or ended streams.
  """
  def get_lives(filters \\ %{"lookback_hours" => "0", "max_upcoming_hours" => "96"}) do
    path = "/v1/live"
    url =
      @holofans_api_base
      |> URI.parse()
      |> URI.merge(path)
      |> Map.put(:query, URI.encode_query(filters))
      |> URI.to_string()

    Logger.debug("Making request to URL: #{url}")

    req = Finch.build(:get, url)

    {:ok, resp} = Finch.request(req, HolofansAPIClient)
    {:ok, lives} = resp.body |> Jason.decode()
    lives["live"] ++ lives["upcoming"] ++ lives["ended"]
  end
end
