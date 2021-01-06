defmodule Holobot.Holofans.Channels do
  @moduledoc """
  Holofans API channels context.
  """

  @type channel :: %{
          name: binary(),
          subscriber_count: integer(),
          yt_channel_id: binary(),
          twitter_link: binary()
        }

  require Logger

  @spec get_channels :: list(channel())
  def get_channels(filter \\ %{"sort" => "name"}) do
    get_channel_resource("/v1/channels", filter) |> Map.get("channels")
  end

  def get_channel(holoapi_id) when is_integer(holoapi_id) do
    get_channel(Integer.to_string(holoapi_id))
  end

  @spec get_channel(binary) :: channel()
  def get_channel(holoapi_id) when is_bitstring(holoapi_id) do
    get_channel_resource("/v1/channels/#{holoapi_id}")
  end

  @spec get_channel_yt(binary) :: channel()
  def get_channel_yt(yt_id) do
    get_channel_resource("/v1/channels/youtube/#{yt_id}")
  end

  defp get_channel_resource(path, params \\ %{}) do
    holofans_api_base = Application.fetch_env!(:holobot, :holofans_api)

    url =
      holofans_api_base
      |> URI.parse()
      |> URI.merge(path)
      |> Map.put(:query, URI.encode_query(params))
      |> URI.to_string()

    Logger.debug("Making request to URL: #{url}")

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, decoded} = Jason.decode(body)
        decoded

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.warning("Resource not found")

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error(reason)
    end
  end
end
