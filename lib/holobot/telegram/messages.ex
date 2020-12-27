defmodule Holobot.Telegram.Messages do
  @moduledoc """
  Telegram chat context.
  """

  require Logger
  require Nadia

  @yt_vid_url_base "https://www.youtube.com/watch?v="

  @doc """
  Sends a formatted list of live stream entries in one single message to a Telegram chat.
  """
  @spec build_live_list_msg(maybe_improper_list) :: binary()
  def build_live_list_msg(lives) when is_list(lives) do
    live_channels_body =
      lives
      |> Stream.map(&build_live_msg_entry/1)
      |> Enum.join()

    "*Live channels:*\n\n" <> live_channels_body
  end

  def build_upcoming_live_list(lives) when is_list(lives) do
    upcoming_body =
      lives
      |> Stream.map(&build_live_msg_entry/1)
      |> Enum.join()

    "*Upcoming streams*\n\n" <> upcoming_body
  end

  @doc """
  Returns bot help message.
  """
  @spec build_help_msg() :: binary()
  def build_help_msg() do
    msg =
      "*A-Chan* is a helpful Hololive bot that provides information about Hololive videos, live streams and channels!

*List of commands*

`/live [time]` - get list of livestreams that either already started or will start `[time]` into the future, e.g. `/live now`"
    msg
  end

  defp build_live_msg_entry(live) do
    %{"channel" => %{"name" => name}, "yt_video_key" => yt, "title" => title} = live

    # TODO: Refactor this hacky solution to non-escaped square brackets in titles when Markdown
    # parse mode is being used. Build message in HTML instead.
    clean_title =
      title
       |> String.replace("[", "|")
       |> String.replace("]", "|")

    "#{name} [#{clean_title}](#{@yt_vid_url_base}#{yt})\n"
  end
end
