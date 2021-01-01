defmodule Holobot.Telegram.Commands.Inline.Live do
  @moduledoc """
  Live inline command handler module.
  """

  use Holobot.Telegram.Commander

  alias Holobot.Holofans.Lives
  alias Holobot.Telegram.Messages

  def live(update) do
    Logger.info("Inline Query Command /live")
    %{"live" => livestreams} = Lives.get_lives!(%{"lookback_hours" => "0"})

    :ok =
      livestreams
      |> Messages.build_live_articles_inline()
      |> answer_inline_query()
  end
end
