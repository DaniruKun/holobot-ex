defmodule Holobot.Holofans.Video do
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
end
