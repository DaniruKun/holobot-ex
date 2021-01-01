defmodule Holobot.Telegram.Commands.Channels do
  @moduledoc """
  Channels query command handler.
  """
  use Holobot.Telegram.Commander

  alias Holobot.Holofans
  alias Holobot.Telegram.Messages

  @default_msg_opts [{:parse_mode, "Markdown"}, {:disable_web_page_preview, true}]

  def channels(update) do
    Logger.info("Command /channels")

    {:ok, _} =
      send_message("Which channels would you like to see?",
        reply_markup: %Model.InlineKeyboardMarkup{
          inline_keyboard: [
            [
              %{
                callback_data: "/channels all",
                text: "All"
              },
              %{
                callback_data: "/channels top-subs",
                text: "Top sub count"
              },
              %{
                callback_data: "/channels top-views",
                text: "Top view count"
              }
            ]
          ]
        }
      )
  end

  def channels_query_command(update) do
    command = update.callback_query.data
    Logger.info("Callback Query Command #{command}")

    channels =
      case command do
        "/channels all" ->
          answer_callback_query(text: "Showing all channels.")

          Holofans.Channels.get_channels(%{"limit" => "50", "order" => "desc"})

        "/channels top-subs" ->
          answer_callback_query(text: "Showing top 10 channels by sub count.")

          Holofans.Channels.get_channels(%{
            "sort" => "subscriber_count",
            "limit" => "10",
            "order" => "desc"
          })

        "/channels top-views" ->
          answer_callback_query(text: "Showing top 10 channels by view count.")

          Holofans.Channels.get_channels(%{
            "sort" => "view_count",
            "limit" => "10",
            "order" => "desc"
          })
      end

    channels
    |> Messages.build_channels_list_msg()
    |> send_message(@default_msg_opts)
  end
end
