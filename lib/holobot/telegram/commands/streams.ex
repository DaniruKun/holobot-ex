defmodule Holobot.Telegram.Commands.Streams do
  @moduledoc """
  Streams query command handler.
  """
  use Holobot.Telegram.Commander

  alias Holobot.Helpers

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
end
