defmodule Holobot.Holofans.Video do
  @moduledoc """
  Video record schema and helper functions.
  """
  use Memento.Table,
    attributes: [
      :yt_video_key,
      :title,
      :live_schedule,
      :live_start,
      :live_end,
      :live_viewers,
      :channel,
      :is_uploaded,
      :duration_secs,
      :is_captioned
    ],
    index: [:title, :channel],
    type: :ordered_set

  @spec build_record(map) :: struct()
  def build_record(video) do
    %__MODULE__{
      yt_video_key: video["yt_video_key"],
      title: video["title"],
      live_schedule: video["live_schedule"],
      live_start: video["live_start"],
      live_end: video["live_end"],
      live_viewers: video["live_viewers"],
      channel: video["channel"],
      is_uploaded: video["is_uploaded"],
      duration_secs: video["duration_secs"],
      is_captioned: video["is_captioned"]
    }
  end
end
