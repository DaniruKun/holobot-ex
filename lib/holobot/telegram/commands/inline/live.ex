defmodule Holobot.Telegram.Commands.Inline.Live do
  @moduledoc """
  Live inline command handler module.
  """

  use Holobot.Telegram.Commander

  alias Holobot.Holofans.Videos
  alias Holobot.Telegram.Messages

  def live(update) do
    Logger.info("Inline Query Command /live")

    :ok =
      Videos.get_lives()
      |> Messages.build_live_articles_inline()
      |> answer_inline_query()
  end
end
