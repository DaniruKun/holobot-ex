defmodule Holobot.Telegram.Commands.Streams do
  @moduledoc """
  Streams query command handler.
  """
  use Holobot.Telegram.Commander

  alias Holobot.Helpers
  alias Holobot.Telegram.Messages
  alias Holobot.Holofans.Lives

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
                callback_data: "/choose live",
                text: "Live"
              },
              %{
                callback_data: "/choose upcoming",
                text: "Upcoming"
              },
              %{
                callback_data: "/choose ended",
                text: "Ended"
              }
            ]
          ]
        }
      )
  end

  def streams_query_command(update) do
    Logger.info("Callback Query Command /choose")

    case update.callback_query.data do
      "/choose live" ->
        answer_callback_query(text: "Showing live streams.")
        %{"live" => live} = Lives.get_lives!(%{"lookback_hours" => "0"})

        live
        |> Messages.build_live_msg()
        |> send_message(@default_msg_opts)

      "/choose upcoming" ->
        answer_callback_query(text: "Showing upcoming streams.")
        %{"upcoming" => upcoming} = Lives.get_lives!(%{"lookback_hours" => "0"})

        upcoming
        |> Messages.build_upcoming_msg()
        |> send_message(@default_msg_opts)

      "/choose ended" ->
        answer_callback_query(text: "Showing ended streams.")
        %{"ended" => ended} = Lives.get_lives!(%{"max_upcoming_hours" => "0"})

        ended
        |> Messages.build_ended_msg()
        |> send_message(@default_msg_opts)
    end
  end
end
