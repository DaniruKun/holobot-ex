defmodule Holobot.Holofans.Video do
  defstruct [
    :id,
    :yt_video_key,
    :bb_video_id,
    :title,
    :thumbnail,
    :live_schedule,
    :live_start,
    :live_end,
    :live_viewers,
    :channel,
    :duration_secs,
    :is_captioned,
    is_uploaded: true
  ]
end
