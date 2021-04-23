defmodule Holobot.Holofans.Channel do
  @moduledoc """
  Channel record schema and helper functions.
  """
  use Memento.Table,
    attributes: [
      :yt_channel_id,
      :name,
      :description,
      :twitter_link,
      :view_count,
      :subscriber_count,
      :video_count,
      :photo
    ],
    index: [:name],
    type: :set

  @type t() :: %__MODULE__{
          yt_channel_id: binary(),
          name: binary(),
          description: binary(),
          twitter_link: binary(),
          view_count: pos_integer(),
          subscriber_count: pos_integer(),
          video_count: pos_integer(),
          photo: binary()
        }

  @spec build_record(nil | maybe_improper_list | map) :: t()
  def build_record(channel) do
    %__MODULE__{
      yt_channel_id: channel["yt_channel_id"],
      name: channel["name"],
      description: channel["description"] |> String.split("\n") |> Enum.at(0),
      twitter_link: channel["twitter_link"],
      view_count: channel["view_count"],
      subscriber_count: channel["subscriber_count"],
      video_count: channel["video_count"],
      photo: channel["photo"]
    }
  end
end
