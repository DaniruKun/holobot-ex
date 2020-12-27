defmodule Holobot.Telegram.Commands.Live do
  use Holobot.Telegram.Commander

  alias Holobot.Holofans.Lives
  alias Holobot.Telegram.Messages

  def live(update) do
    parsed = String.split(update.message.text, " ")
    args = case length(parsed) do
      1 -> nil
      _ -> tl(parsed)
    end

    Logger.info("Command /live #{args}")

    msg = Lives.get_lives!() |> Messages.build_live_list_msg()

    send_message(msg, [{:parse_mode, "Markdown"}, {:disable_web_page_preview, true}])
  end
end
