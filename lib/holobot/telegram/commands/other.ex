defmodule Holobot.Telegram.Commands.Other do
  @moduledoc """
  Other messages handler.
  """
  use Holobot.Telegram.Commander

  alias Holobot.Helpers

  def other(update) do
    Logger.info("Message: #{update.message.text}")
    # resp = update.message.text |> Helpers.tokenize_msg() |> Helpers.parse()

    # if resp do
    #   {:ok, _} = send_message(resp)
    # end
  end
end
