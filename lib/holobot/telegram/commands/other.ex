defmodule Holobot.Telegram.Commands.Other do
  @moduledoc """
  Other messages handler.
  """
  use Holobot.Telegram.Commander

  def other(update) do
    if Map.has_key?(update, :message) do
      Logger.debug("Message: #{update.message.text}")
    end
  end
end
