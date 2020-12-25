defmodule Holobot.Telegram.Chat do
  @moduledoc """
  Telegram chat context.
  """

  require Logger
  require Nadia

  @yt_vid_url_base "https://www.youtube.com/watch?v="

  def send_live_list(lives) when is_list(lives) do
    msg_body =
      lives
      |> Enum.each(fn live ->
        "*#{live.channel.name}* [#{@yt_vid_url_base}#{live.yt_video_key}](#{live.title})\n"
      end)

    Logger.info("Message body:\n#{msg_body}")
  end

  @spec send_help_msg(integer | binary) :: {:error, Nadia.Model.Error.t()} | {:ok, Nadia.Model.Message.t()}
  def send_help_msg(chat_id) do
    msg =
      "**A-Chan** is a helpful Hololive bot that provides information about Hololive videos, live streams and channels!

Some commands you can use:
`/live [time]` - get list of livestreams that either already started or will start `[time]` into the future, e.g. `/live now`"

    Nadia.send_message(chat_id, msg, [{:parse_mode, "Markdown"}])
  end
end
