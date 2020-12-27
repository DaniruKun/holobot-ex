defmodule Holobot.Holofans.Videos do
  @moduledoc """
  Holofans API videos context.
  """

  @holofans_api_base Application.fetch_env!(:holobot, :holofans_api)

  require Finch

  def get_videos!(attrs) do
    qparams = URI.encode_query(attrs)
    req = Finch.build(:get, @holofans_api_base <> "v1/videos?#{qparams}")
    {:ok, resp} = Finch.request(req, HolofansAPIClient)
    {:ok, decoded_body} = Jason.decode(resp.body)
    decoded_body
  end

  def get_video!(yt_video_id, attrs \\ %{with_comments: 0}) do
    qparams = URI.encode_query(attrs)
    req = Finch.build(:get, @holofans_api_base <> "v1/videos/youtube/#{yt_video_id}?#{qparams}")
    {:ok, resp} = Finch.request(req, HolofansAPIClient)
    {:ok, decoded_body} = Jason.decode(resp.body)
    decoded_body
  end
end
