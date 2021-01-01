defmodule Holobot.Telegram.Commands do
  @moduledoc """
  Commands handler module.
  """
  use Holobot.Telegram.Commander
  use Holobot.Telegram.Router

  alias Holobot.Telegram.Commands.Streams
  alias Holobot.Telegram.Commands.Channels
  alias Holobot.Telegram.Commands.Other
  alias Holobot.Telegram.Commands.Inline.Live

  require Logger

  command("start") do
    Logger.info("Command /start")

    send_message("A-Chan bot started! Type `/help` to learn more.", [{:parse_mode, "Markdown"}])
  end

  command("help") do
    Logger.info("Command /help")

    send_message(Holobot.Telegram.Messages.build_help_msg(), [{:parse_mode, "Markdown"}])
  end

  command("streams", Streams, :streams)

  callback_query_command("choose", Streams, :streams_query_command)

  command("channels", Channels, :channels)

  callback_query_command("channels", Channels, :channels_query_command)

  command("commands") do
    available_commands = """
    List of available commands:

    /start - Starts the bot
    /help - Get info about A-Chan
    /streams - Get a list of live streams interactively
    /channels - Get a list of channels interactively
    /commands - Shows this list of commands
    """

    send_message(available_commands)
  end

  inline_query_command("live", Live, :live)

  # Advanced Stuff
  #
  # Now that you already know basically how this boilerplate works let me
  # introduce you to a cool feature that happens under the hood.
  #
  # If you are used to telegram bot API, you should know that there's more
  # than one path to fetch the current message chat ID so you could answer it.
  # With that in mind and backed upon the neat macro system and the cool
  # pattern matching of Elixir, this boilerplate automatically detectes whether
  # the current message is a `inline_query`, `callback_query` or a plain chat
  # `message` and handles the current case of the Nadia method you're trying to
  # use.
  #
  # If you search for `defmacro send_message` at App.Commander, you'll see an
  # example of what I'm talking about. It just works! It basically means:
  # When you are with a callback query message, when you use `send_message` it
  # will know exatcly where to find it's chat ID. Same goes for the other kinds.

  inline_query_command "foo" do
    Logger.log(:info, "Inline Query Command /foo")
    # Where do you think the message will go for?
    # If you answered that it goes to the user private chat with this bot,
    # you're right. Since inline querys can't receive nothing other than
    # Nadia.InlineQueryResult models. Telegram bot API could be tricky.
    send_message("This came from an inline query")
  end

  # Fallbacks

  # Rescues any unmatched callback query.
  callback_query do
    Logger.log(:warn, "Did not match any callback query")

    # answer_callback_query(text: "Sorry, but there is no JoJo better than Joseph.")
  end

  # Rescues any unmatched inline query.
  inline_query do
    Logger.log(:warn, "Did not match any inline query")

    :ok =
      answer_inline_query([
        %InlineQueryResult.Article{
          id: "1",
          title: "Darude-Sandstorm Non non Biyori Renge Miyauchi Cover 1 Hour",
          thumb_url: "https://img.youtube.com/vi/yZi89iQ11eM/3.jpg",
          description: "Did you mean Darude Sandstorm?",
          input_message_content: %{
            message_text: "https://www.youtube.com/watch?v=yZi89iQ11eM"
          }
        }
      ])
  end

  # Fallback message handler.
  message(Other, :other)
end
