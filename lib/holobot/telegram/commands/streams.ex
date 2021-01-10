defmodule Holobot.Telegram.Commands.Streams do
  @moduledoc """
  Streams query command handler.
  """
  use Holobot.Telegram.Commander

  alias Holobot.Helpers
  alias Holobot.Telegram.Messages
  alias Holobot.Holofans.Videos

  @default_msg_opts [{:parse_mode, "Markdown"}, {:disable_web_page_preview, true}]
  def streams(update) do
    args = Helpers.tokenize_msg(update.message.text)

    Logger.info("Command /streams #{args}")

    {:ok, _} =
      send_message("Which streams would you like to get?",
        reply_markup: %Model.InlineKeyboardMarkup{
          inline_keyboard: [
            [
              %{
                callback_data: "/streams live",
                text: "Live"
              },
              %{
                callback_data: "/streams upcoming",
                text: "Upcoming"
              }
              # %{
              #   callback_data: "/choose ended",
              #   text: "Ended"
              # }
            ]
          ]
        }
      )
  end

  def streams_query_command(update) do
    Logger.info("Callback Query Command /streams")

    case update.callback_query.data do
      "/streams live" ->
        answer_callback_query(text: "Showing live streams.")

        Videos.get_lives()
        |> Messages.build_msg_for_status(:live)
        |> send_message(@default_msg_opts)

      "/streams upcoming" ->
        answer_callback_query(text: "Showing upcoming streams.")

        Videos.get_upcoming()
        |> Messages.build_msg_for_status(:upcoming)
        |> send_message(@default_msg_opts)

      "/streams ended" ->
        answer_callback_query(text: "Showing ended streams.")

        # TODO: Implement me
    end
  end
end
