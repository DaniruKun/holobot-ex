defmodule Holobot.Telegram.Messages do
  @moduledoc """
  Telegram messages context.
  """

  require Logger
  require Nadia

  alias Holobot.Helpers

  @yt_vid_url_base "https://youtu.be/"

  @doc """
  Builds a formatted list of currently live streams.
  """
  @spec build_live_msg(maybe_improper_list) :: binary()
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
  @spec build_upcoming_msg(maybe_improper_list) :: binary()
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
  @spec build_ended_msg(maybe_improper_list) :: binary()
  def build_ended_msg(lives) when is_list(lives) do
    ended_body =
      lives
      |> Stream.map(&build_live_msg_entry/1)
      |> Enum.join()

    "⏹ *Ended streams*\n\n" <> ended_body
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

  @spec build_live_msg_entry(%{
          channel: %{name: binary()},
          yt_video_key: binary(),
          title: binary(),
          live_schedule: binary(),
          live_start: binary()
        }) :: binary()
  defp build_live_msg_entry(live) do
    %{
      "channel" => channel,
      "yt_video_key" => yt,
      "title" => title,
      "live_schedule" => scheduled_start,
      "live_start" => actual_start
    } = live

    # TODO: Refactor this hacky solution to non-escaped square brackets in titles when Markdown
    # parse mode is being used. Build message in HTML instead.
    clean_title =
      title
      |> String.replace("[", "|")
      |> String.replace("]", "|")

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

    "#{ch_emoji}#{channel["name"]}\n" <>
      time_formatted <>
      "\n[#{clean_title}](#{@yt_vid_url_base}#{yt})\n\n"
  end

  defp zero_pad(number, amount \\ 2) do
    number
    |> Integer.to_string()
    |> String.pad_leading(amount, "0")
  end
end
