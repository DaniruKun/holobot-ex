defmodule Holobot.Telegram.Chat do
  @moduledoc """
  Telegram chat context.
  """

  require Logger
  require Nadia

  @yt_vid_url_base "https://www.youtube.com/watch?v="

  @spec send_live_list!(integer | binary, maybe_improper_list) :: {:ok, Nadia.Model.Message.t()}
  def send_live_list!(chat_id, lives) when is_list(lives) do
    live_channels_body =
      lives
      |> Stream.map(&build_live_msg_entry/1)
      |> Enum.join()

    msg = "*Currently live channels:*\n\n" <> live_channels_body

    Logger.debug("Message body:\n#{live_channels_body}")

    {:ok, _} = Nadia.send_message(chat_id, msg, [
      {:parse_mode, "Markdown"},
      {:disable_web_page_preview, true}
    ])
  end

  @spec send_help_msg!(integer | binary) ::
          {:error, Nadia.Model.Error.t()} | {:ok, Nadia.Model.Message.t()}
  def send_help_msg!(chat_id) do
    msg =
      "**A-Chan** is a helpful Hololive bot that provides information about Hololive videos, live streams and channels!

Some commands you can use:
`/live [time]` - get list of livestreams that either already started or will start `[time]` into the future, e.g. `/live now`"

    {:ok, _} = Nadia.send_message(chat_id, msg, [{:parse_mode, "Markdown"}])
  end

  defp build_live_msg_entry(live) do
    %{"channel" => %{"name" => name}, "yt_video_key" => yt, "title" => title} = live

    clean_title =
      title
       |> String.replace("[", "|")
       |> String.replace("]", "|")

    "#{name} [#{clean_title}](#{@yt_vid_url_base}#{yt})\n"
  end
end
