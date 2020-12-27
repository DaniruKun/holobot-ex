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
      "I am A-Chan (友人A), I can answer any questions about Hololive streams, channels and other things!

You can add me to a group or ask me questions directly. To view a full list of commands, either just start typing `/` or type `/commands`
"

    msg
  end

  defp build_live_msg_entry(live) do
    %{
      "channel" => %{"name" => ch_name},
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

    time =
      if actual_start do
        # Already started
        {:ok, start, 0} = DateTime.from_iso8601(actual_start)
        "#{start.hour}:#{start.minute |> zero_pad}"
      else
        # Hasn't started yet
        {:ok, start, 0} = DateTime.from_iso8601(scheduled_start)
        "#{start.hour}:#{start.minute |> zero_pad}"
      end

    time_formatted = "Starts at: #{time} (UTC)\n"

    "#{ch_name}\n" <> time_formatted <> "[#{clean_title}](#{@yt_vid_url_base}#{yt})\n\n"
  end

  defp zero_pad(number, amount \\ 2) do
    number
    |> Integer.to_string()
    |> String.pad_leading(amount, "0")
  end
end
