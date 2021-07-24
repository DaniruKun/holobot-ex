defmodule Holobot.Holofans.Video do
  @moduledoc """
  Video record schema and helper functions.
  """
  use Memento.Table,
    attributes: [
      :yt_video_key,
      :title,
      :status,
      :live_schedule,
      :live_start,
      :live_end,
      :live_viewers,
      :channel,
      :is_uploaded,
      :duration_secs,
      :is_captioned
    ],
    index: [:title],
    type: :set

  @type t() :: %__MODULE__{
          yt_video_key: binary(),
          title: binary(),
          status: binary(),
          live_schedule: binary(),
          live_start: binary() | nil,
          live_end: binary() | nil,
          live_viewers: pos_integer() | nil,
          channel: map(),
          is_uploaded: boolean(),
          is_captioned: boolean()
        }

  @spec build_record(map) :: t()
  def build_record(video) do
    %__MODULE__{
      yt_video_key: video["yt_video_key"],
      title: video["title"],
      status: video["status"],
      live_schedule: video["live_schedule"],
      live_start: video["live_start"],
      live_end: video["live_end"],
      live_viewers: video["live_viewers"],
      channel: video["channel"]["yt_channel_id"],
      is_uploaded: video["is_uploaded"],
      duration_secs: video["duration_secs"],
      is_captioned: video["is_captioned"]
    }
  end
 
end
