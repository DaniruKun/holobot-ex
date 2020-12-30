defmodule Holobot.Telegram.Commands.Streams do
  @moduledoc """
  Streams query command handler.
  """
  use Holobot.Telegram.Commander

  def streams_q(update) do
    args = process_args(update.message.text)

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
            ],
            [
              # Read about fallbacks in the end of the file
              %{
                callback_data: "/typo-:p",
                text: "Other"
              }
            ]
          ]
        }
      )
  end

  defp process_args(msg_text) do
    parsed = String.split(msg_text, " ")

    if length(parsed) == 1 do
      nil
    else
      tl(parsed)
    end
  end
end
