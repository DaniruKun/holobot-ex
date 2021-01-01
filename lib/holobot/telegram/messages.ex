defmodule Holobot.Telegram.Messages do
  @moduledoc """
  Telegram messages context.

  Contains functions related to building and manipulating messages and structs for Telegram.
  """

  require Logger
  require Nadia

  alias Holobot.Helpers
  alias Nadia.Model.InlineQueryResult.Article

  @type channel :: %{
          name: binary(),
          subscriber_count: integer(),
          yt_channel_id: binary(),
          twitter_link: binary()
        }
  @type live :: %{
          channel: channel(),
          yt_video_key: binary(),
          title: binary(),
          live_schedule: binary(),
          live_start: binary()
        }

  @yt_vid_url_base "https://youtu.be/"

  @doc """
  Builds a formatted list of currently live streams.
  """
  @spec build_live_msg(list(live())) :: binary()
  def build_live_msg(lives) when is_list(lives) do
    live_channels_body =
      lives
      |> Stream.map(&build_live_msg_entry/1)
      |> Enum.join()

    "🔴 *Live channels*\n\n" <> live_channels_body
  end

  @doc """
  Builds a formatted list of upcoming live streams.
  """
  @spec build_upcoming_msg(list(live())) :: binary()
  def build_upcoming_msg(lives) when is_list(lives) do
    upcoming_body =
      lives
      |> Stream.map(&build_live_msg_entry/1)
      |> Enum.join()

    "⏰ *Upcoming streams*\n\n" <> upcoming_body
  end

  @doc """
  Builds a formatted list of ended live streams.
  """
  @spec build_ended_msg(list(live())) :: binary()
  def build_ended_msg(lives) when is_list(lives) do
    ended_body =
      lives
      |> Stream.map(&build_live_msg_entry/1)
      |> Enum.join()

    "⏹ *Ended streams*\n\n" <> ended_body
  end

  @spec build_channels_list_msg(list(channel())) :: binary()
  def build_channels_list_msg(channels) do
    channels_body =
      channels
      |> Stream.map(&build_channel_entry/1)
      |> Enum.join()

    "*Channels*\n\n" <> channels_body
  end

  @doc """
  Returns bot help message.
  """
  @spec build_help_msg() :: binary()
  def build_help_msg() do
    """
    I am A-Chan (友人A), I can answer any questions about Hololive streams, channels and other things!

    You can add me to a group or ask me questions directly. To view a full list of commands, either just start typing `/` or type /commands
    """
  end

  @spec build_live_articles_inline(list(live())) :: list(%Article{})
  def build_live_articles_inline(lives) do
    lives |> Enum.map(&build_live_article/1)
  end

  @spec build_live_msg_entry(live()) :: binary()
  defp build_live_msg_entry(live) do
    %{
      "channel" => channel,
      "yt_video_key" => yt,
      "title" => title,
      "live_schedule" => scheduled_start,
      "live_start" => actual_start
    } = live

    {:ok, datetime_start, 0} =
      if actual_start do
        # Already started
        DateTime.from_iso8601(actual_start)
      else
        # Hasn't started yet
        DateTime.from_iso8601(scheduled_start)
      end

    datetime_now = DateTime.utc_now()

    time_formatted =
      case DateTime.compare(datetime_now, datetime_start) do
        :gt -> "Started *#{trunc(DateTime.diff(datetime_now, datetime_start) / 60)}* minutes ago"
        :lt -> "Starts in *#{trunc(DateTime.diff(datetime_start, datetime_now) / 60)}* minutes"
        :eq -> "Live now!"
      end

    ch_emoji = Helpers.get_channel_emoji(channel)

    """
    #{ch_emoji}#{channel["name"]}
    #{time_formatted}
    [#{clean_title(title)}](#{@yt_vid_url_base}#{yt})

    """
  end

  @spec build_channel_entry(any()) :: binary()
  defp build_channel_entry(channel) do
    %{
      "name" => name,
      "subscriber_count" => subs,
      "yt_channel_id" => ch_id,
      "twitter_link" => twitter
    } = channel

    ch_emoji = Helpers.get_channel_emoji(channel)

    """
    #{ch_emoji}[#{name}](https://www.youtube.com/channel/#{ch_id})
    #{trunc(subs / 1000)}K Subscribers
    [Twitter](https://twitter.com/#{twitter})

    """
  end

  @spec build_live_article(live()) :: %Article{}
  defp build_live_article(live) do
    %Article{
      id: Enum.random(1..100),
      title: live["title"],
      thumb_url: "https://img.youtube.com/vi/#{live["yt_video_key"]}/sddefault.jpg",
      thumb_width: 640,
      thumb_height: 480,
      description: live["channel"]["name"],
      url: "https://www.youtu.be/#{live["yt_video_key"]}",
      input_message_content: %{
        message_text: "https://www.youtu.be/#{live["yt_video_key"]}"
      }
    }
  end

  defp zero_pad(number, amount \\ 2) do
    number
    |> Integer.to_string()
    |> String.pad_leading(amount, "0")
  end

  defp clean_title(title) do
    # TODO: Refactor this hacky solution to non-escaped square brackets in titles when Markdown
    # parse mode is being used. Build message in HTML instead.
    title
    |> String.replace("[", "|")
    |> String.replace("]", "|")
  end
end
