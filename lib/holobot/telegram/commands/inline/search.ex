defmodule Holobot.Telegram.Commands.Inline.Search do
  @moduledoc """
  Inline search query handler.
  """
  use Holobot.Telegram.Commander

  alias Holobot.Holofans.Video
  alias Holobot.Holofans.Videos
  alias Holobot.Telegram.Messages

  def search(update) do
    query = update.inline_query.query

    if String.length(query) >= 3 and String.length(query) < 15 do
      Logger.debug("Inline query #{query}")

      :ok =
        Videos.search_query(query)
        |> Enum.map(&Video.build_record/1)
        |> Messages.build_live_articles_inline()
        |> answer_inline_query()
    end
  end
end
