defmodule Holobot.Telegram.Commands.Live do
  use Holobot.Telegram.Commander

  alias Holobot.Holofans.Lives
  alias Holobot.Telegram.Messages

  def live(update) do
    # Parse arguments if any and prepare to pass down.
    parsed = String.split(update.message.text, " ")

    args =
      case length(parsed) do
        1 -> nil
        _ -> tl(parsed)
      end

    Logger.info("Command /live #{args}")

    # Build message to send to Telegram
    live_msg = Lives.get_lives!() |> Map.get("live") |> Messages.build_live_list_msg()

    send_message(live_msg, [{:parse_mode, "Markdown"}, {:disable_web_page_preview, true}])
  end
end
