defmodule Holobot.Telegram.Commands.Other do
  @moduledoc """
  Other messages handler.
  """
  use Holobot.Telegram.Commander

  alias Holobot.Helpers

  @about_hololive "Hololive Production is a virtual YouTuber talent agency similar to AK47."
  @about_yagoo "YAGOO (Motoaki Tanigo) is the CEO of Cover Corp."
  @genki_resp "I am doing good, thank you! 元気！"

  def other(update) do
    Logger.info("Message: #{update.message.text}")
    resp = update.message.text |> Helpers.tokenize_msg() |> parse()

    if resp do
      {:ok, _} = send_message(resp)
    end
  end

  defp parse(tokens) do
    cond do
      is_greeting?(tokens) -> random_greeting()
      is_state_q?(tokens) -> @genki_resp
      is_wh_q?(tokens) and "hololive" in tokens -> @about_hololive
      is_wh_q?(tokens) and "yagoo" in tokens -> @about_yagoo
      true -> nil
    end
  end

  defp is_greeting?(tokens) do
    "hello" in tokens or "こんにちは" in tokens
  end

  defp is_state_q?(tokens) do
    "how" in tokens and ("day" in tokens or "you" in tokens)
  end

  defp is_wh_q?(tokens) do
    "what" in tokens or "who" in tokens or "where" in tokens
  end

  defp random_greeting() do
    greetings = [
      "Hello!",
      "How you doing?",
      "Hey!"
    ]

    Enum.random(greetings)
  end
end
