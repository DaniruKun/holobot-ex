defmodule Holobot.Telegram.Commands.Inline.Channels do
  use Holobot.Telegram.Commander

  alias Holobot.Holofans.Channels
  alias Holobot.Telegram.Messages
  alias Holobot.Helpers

  # Limit results since there is a hard limit in Telegram API
  @max_results 5

  @spec channels(atom | %{inline_query: atom | %{id: binary, query: binary}}) :: :ok | nil
  def channels(update) do
    query = update.inline_query.query |> Helpers.tokenize_msg() |> Enum.at(1, :none)

    Logger.info("Inline query command /channels query: #{query}")

    all_channels = Channels.get_channels()

    results =
      case query do
        :none ->
          all_channels

        _ ->
          Channels.search(all_channels, query)
      end

    :ok =
      results
      |> Stream.take(@max_results)
      |> Messages.build_channel_articles_inline()
      |> answer_inline_query()
  end
end
