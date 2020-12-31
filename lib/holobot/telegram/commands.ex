defmodule Holobot.Telegram.Commands do
  @moduledoc """
  Commands handler module.
  """
  use Holobot.Telegram.Commander
  use Holobot.Telegram.Router

  alias Holobot.Telegram.Commands.Streams
  alias Holobot.Telegram.Commands.Other
  alias Holobot.Telegram.Messages

  alias Holobot.Holofans.Lives
  alias Holobot.Telegram.Messages

  require Logger

  @default_msg_opts [{:parse_mode, "Markdown"}, {:disable_web_page_preview, true}]

  command("start") do
    Logger.info("Command /start")

    send_message("A-Chan bot started! Type `/help` to learn more.", [{:parse_mode, "Markdown"}])
  end

  command("help") do
    Logger.info("Command /help")

    send_message(Messages.build_help_msg(), [{:parse_mode, "Markdown"}])
  end

  command("streams", Streams, :streams_q)

  command("commands") do
    available_commands = """
    List of available commands:

    /start - Starts the bot
    /help - Get info about A-Chan
    /streams - Get a list of live streams interactively
    /commands - Shows this list of commands

    """

    send_message(available_commands)
  end

  # You can create command interfaces for callback queries using this macro.
  callback_query_command "choose" do
    Logger.info("Callback Query Command /choose")

    case update.callback_query.data do
      "/choose live" ->
        answer_callback_query(text: "Showing live streams.")
        %{"live" => live} = Lives.get_lives!(%{"lookback_hours" => "0"})

        live
        |> Messages.build_live_msg()
        |> send_message(@default_msg_opts)

      "/choose upcoming" ->
        answer_callback_query(text: "Showing upcoming streams.")
        %{"upcoming" => upcoming} = Lives.get_lives!(%{"lookback_hours" => "0"})

        upcoming
        |> Messages.build_upcoming_msg()
        |> send_message(@default_msg_opts)

      "/choose ended" ->
        answer_callback_query(text: "Showing ended streams.")
        %{"ended" => ended} = Lives.get_lives!(%{"max_upcoming_hours" => "0"})

        ended
        |> Messages.build_ended_msg()
        |> send_message(@default_msg_opts)
    end
  end

  # You may also want make commands when in inline mode.
  # Be sure to enable inline mode first: https://core.telegram.org/bots/inline
  # Try by typping "@your_bot_name /what-is something"
  # This will execute a query after the user stops typing in the query input
  inline_query_command "what-is" do
    Logger.log(:info, "Inline Query Command /what-is")

    :ok =
      answer_inline_query([
        %InlineQueryResult.Article{
          id: "1",
          title: "10 Hours What is Love Jim Carrey HD",
          thumb_url: "https://img.youtube.com/vi/ER97mPHhgtM/3.jpg",
          description: "Have a great time",
          input_message_content: %{
            message_text: "https://www.youtube.com/watch?v=ER97mPHhgtM"
          }
        }
      ])
  end

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

    answer_callback_query(text: "Sorry, but there is no JoJo better than Joseph.")
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
