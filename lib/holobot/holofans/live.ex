defmodule Holobot.Holofans.Live do
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
    :state
  ]
end
