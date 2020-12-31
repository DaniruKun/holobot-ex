defmodule Holobot.Telegram.Commands.Other do
  @moduledoc """
  Other messages handler.
  """
  use Holobot.Telegram.Commander

  @about_hololive "Hololive Production is a virtual YouTuber talent agency similar to AK47."
  @about_yagoo "YAGOO (Motoaki Tanigo) is the CEO of Cover Corp."
  @greeting "Hello!"
  @genki_resp "I am doing good, thank you! 元気！"

  def other(update) do
    Logger.info("Message: #{update.message.text}")
    resp = update.message.text |> tokenize() |> parse()

    if resp do
      {:ok, _} = send_message(resp)
    end
  end

  defp tokenize(src) when is_binary(src) do
    src
    |> String.replace(~r/[[:punct:]]/, "")
    |> String.downcase()
    |> String.split()
  end

  defp parse(tokens) do
    cond do
      "hello" in tokens or "こんにちは" in tokens -> @greeting
      "how" in tokens and "day" in tokens -> @genki_resp
      "what" in tokens and "hololive" in tokens -> @about_hololive
      "who" in tokens and "yagoo" in tokens -> @about_yagoo
      true -> nil
    end
  end
end
