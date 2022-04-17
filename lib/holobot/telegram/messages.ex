defmodule Holobot.Telegram.Messages do
  @moduledoc """
  Telegram messages context.

  Contains functions related to building and manipulating messages and structs for Telegram.
  """

  require Logger
  require Nadia

  alias Holobot.Helpers
  alias Holobot.Holofans.{Channel, Channels, Video, Videos}
  alias Nadia.Model.InlineQueryResult.Article

  @yt_vid_url_base "https://youtu.be/"

  @doc """
  Builds a formatted list of live streams for given status.
  """
  @spec build_msg_for_status(list(Video.t()), Videos.video_status()) :: binary()
  def build_msg_for_status(videos, status) do
    body =
      videos
      |> Stream.map(&build_live_msg_entry/1)
      |> Enum.join()

    header =
      case status do
        :live -> "🔴 *Live channels*\n\n"
        :upcoming -> "⏰ *Upcoming streams*\n\n"
        :ended -> "⏹ *Ended streams*\n\n"
        _ -> ""
      end

    header <> body
  end

  @spec build_channels_list_msg(list(Channel.t())) :: binary()
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

    I also support inline queries.
    """
  end

  @doc """
  Returns a list of InlineQueryResultArticle structs with video info.
  """
  @spec build_live_articles_inline(list(Video.t())) :: list(Article.t())
  def build_live_articles_inline(lives) do
    lives |> Enum.map(&build_live_article/1)
  end

  @doc """
  Returns a list of InlineQueryResultArticle structs with channel info.
  """
  @spec build_channel_articles_inline(Enumerable.t()) :: [Article.t()]
  def build_channel_articles_inline(channels) do
    channels |> Enum.map(&build_channel_article/1)
  end

  @spec build_live_msg_entry(Video.t()) :: binary()
  defp build_live_msg_entry(live) do
    %{
      :channel => yt_channel_id,
      :yt_video_key => yt,
      :title => title,
      :live_schedule => scheduled_start,
      :live_start => actual_start
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
        :gt -> "Started *#{build_eta(DateTime.diff(datetime_now, datetime_start))}* ago"
        :lt -> "Starts in *#{build_eta(DateTime.diff(datetime_start, datetime_now))}*"
        :eq -> "Live now!"
      end

    # TODO: Handle ended streams (when status is ended)

    ch_emoji = Helpers.get_channel_emoji(yt_channel_id)

    channel = Channels.get_channel(yt_channel_id)

    if !channel, do: throw(:channel_not_found)

    """
    #{ch_emoji}#{channel.name}
    #{time_formatted}
    [#{clean_title(title)}](#{@yt_vid_url_base}#{yt})

    """
  end

  defp build_channel_entry(channel) do
    %{
      name: name,
      subscriber_count: subs,
      yt_channel_id: ch_id,
      twitter_link: twitter
    } = channel

    ch_emoji = Helpers.get_channel_emoji(ch_id)

    """
    #{ch_emoji}[#{name}](https://www.youtube.com/channel/#{ch_id})
    #{build_sub_count(subs)}
    [Twitter](https://twitter.com/#{twitter})

    """
  end

  @spec build_live_article(Video.t()) :: Article.t()
  defp build_live_article(live) do
    url = "https://youtu.be/#{live.yt_video_key}"

    %Article{
      id: live.yt_video_key,
      title: live.title,
      thumb_url: "https://img.youtube.com/vi/#{live.yt_video_key}/sddefault.jpg",
      thumb_width: 640,
      thumb_height: 480,
      description: live.channel |> Channels.get_channel() |> Map.get(:name),
      url: url,
      input_message_content: %{
        message_text: url
      }
    }
  end

  @spec build_channel_article(Channel.t()) :: Article.t()
  defp build_channel_article(channel) do
    url = "https://www.youtube.com/channel/#{channel.yt_channel_id}"

    %Article{
      id: channel.yt_channel_id,
      title: channel.name,
      thumb_url: channel.photo,
      thumb_width: 600,
      thumb_height: 600,
      description: build_sub_count(channel.subscriber_count),
      url: url,
      input_message_content: %{
        message_text: """
        <b>#{channel.name}</b>
        <a href="#{channel.photo}">Photo</a>

        <a href="#{url}">Youtube</a> <a href="https://twitter.com/#{channel.twitter_link}">Twitter</a>

        #{channel.description}
        """,
        parse_mode: "HTML"
      }
    }
  end

  @spec build_sub_count(integer) :: binary()
  defp build_sub_count(subs) when is_integer(subs) do
    cond do
      subs < 1_000_000 -> "#{trunc(subs / 1000)}K Subscribers"
      subs >= 1_000_000 -> "#{Float.floor(subs / 1_000_000, 2)}M Subscribers"
    end
  end

  @spec build_eta(integer) :: binary()
  defp build_eta(seconds) when is_integer(seconds) do
    offset = NaiveDateTime.add(~N[2000-01-01 00:00:00], seconds)

    cond do
      seconds < 60 ->
        "#{seconds} seconds"

      seconds < 3_600 ->
        "#{offset.minute} minute" <>
          if offset.minute == 1, do: "", else: "s"

      seconds < 86_400 ->
        "#{offset.hour}h" <>
          if offset.minute == 0,
            do: "",
            else:
              " #{offset.minute} minute" <>
                if(offset.minute == 1, do: "", else: "s")

      true ->
        "#{offset.day} days"
    end
  end

  defp clean_title(title) do
    # TODO: Refactor this hacky solution to non-escaped square brackets in titles when Markdown
    # parse mode is being used. Build message in HTML instead.
    title
    |> String.replace("[", "|")
    |> String.replace("]", "|")
  end
end
