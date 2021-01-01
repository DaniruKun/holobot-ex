defmodule Holobot.Holofans.Channels do
  @moduledoc """
  Holofans API channels context.
  """

  @holofans_api_base Application.fetch_env!(:holobot, :holofans_api)

  alias Holobot.Holofans.Channel
  require Logger
  import Finch

  @spec get_channels :: [Channel]
  def get_channels(filter \\ %{"sort" => "name"}) do
    get_channel_resource("/v1/channels", filter) |> Map.get("channels")
  end

  def get_channel(holoapi_id) when is_integer(holoapi_id) do
    get_channel(Integer.to_string(holoapi_id))
  end

  @spec get_channel(binary) :: Channel
  def get_channel(holoapi_id) when is_bitstring(holoapi_id) do
    get_channel_resource("/v1/channels/#{holoapi_id}")
  end

  @spec get_channel_yt(binary) :: Channel
  def get_channel_yt(yt_id) when is_bitstring(yt_id) do
    get_channel_resource("/v1/channels/youtube/#{yt_id}")
  end

  @spec get_channel_bb(binary) :: Channel
  def get_channel_bb(bb_id) when is_bitstring(bb_id) do
    get_channel_resource("/v1/channels/bilibili/#{bb_id}")
  end

  defp get_channel_resource(resource, params \\ %{}) do
    url =
      @holofans_api_base
      |> URI.parse()
      |> URI.merge(resource)
      |> Map.put(:query, URI.encode_query(params))

    Logger.debug("Making request to URL: #{url}")

    req = build(:get, url)
    {:ok, resp} = request(req, HolofansAPIClient)
    {:ok, decoded_body} = resp.body |> Jason.decode()
    decoded_body
  end
end
