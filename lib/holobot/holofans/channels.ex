defmodule Holobot.Holofans.Channels do
  @moduledoc """
  Holofans API channels context.
  """

  @holofans_api "https://api.holotools.app/v1"

  alias Holobot.Holofans.Channel
  import Finch

  @spec get_channels :: [Channel]
  def get_channels() do
    encoded_query = URI.encode_query(%{"sort" => "name"})
    get_channel_resource("/channels?" <> encoded_query) |> Map.get("channels")
  end

  def get_channel(holoapi_id) when is_integer(holoapi_id) do
    get_channel(Integer.to_string(holoapi_id))
  end

  @spec get_channel(binary) :: Channel
  def get_channel(holoapi_id) when is_bitstring(holoapi_id) do
    get_channel_resource("/channels/" <> holoapi_id)
  end

  @spec get_channel_yt(binary) :: Channel
  def get_channel_yt(yt_id) when is_bitstring(yt_id) do
    get_channel_resource("/channels/youtube/" <> yt_id)
  end

  @spec get_channel_bb(binary) :: Channel
  def get_channel_bb(bb_id) when is_bitstring(bb_id) do
    get_channel_resource("/channels/bilibili/" <> bb_id)
  end

  defp get_channel_resource(resource) do
    req = build(:get, @holofans_api <> resource)
    {:ok, resp} = request(req, HolofansAPIClient)
    {:ok, decoded_body} = resp.body |> Jason.decode()
    decoded_body
  end
end
