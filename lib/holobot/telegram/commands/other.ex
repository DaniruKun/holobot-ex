defmodule Holobot.Telegram.Commands.Other do
  @moduledoc """
  Other messages handler.
  """
  use Holobot.Telegram.Commander

  def other(update) do
    Logger.info("Message: #{update.message.text}")
  end
end
