defmodule Holobot.Holofans.Lives do
  @moduledoc """
  Holofans API lives context.
  """

  require Logger
  require Finch

  @holofans_api_base Application.fetch_env!(:holobot, :holofans_api)

  @spec get_lives!(any) :: map()
  @doc """
  Get a map of currently live, upcoming and/or ended streams.
  """
  def get_lives!(filters \\ %{}) do
    path = "/v1/live"

    def_params = %{
      "max_upcoming_hours" => "12",
      "hide_channel_desc" => "1",
      "lookback_hours" => "6"
    }

    url =
      @holofans_api_base
      |> URI.parse()
      |> URI.merge(path)
      |> Map.put(:query, URI.encode_query(Map.merge(def_params, filters)))
      |> URI.to_string()

    Logger.debug("Making request to URL: #{url}")

    req = Finch.build(:get, url)

    {:ok, resp} = Finch.request(req, HolofansAPIClient)
    {:ok, lives} = resp.body |> Jason.decode()
    lives
  end
end
