defmodule Holobot.Telegram.Commands.Ask do
  @moduledoc """
  Ask query command handler.
  """
  use Holobot.Telegram.Commander

  @about_cover "COVER corp. is a cutting edge 2D entertainment company. It is the parent company of Hololive Production."
  @about_hololive "Hololive Production is a virtual YouTuber talent agency."
  @about_yagoo """
  YAGOO (Motoaki Tanigo) is the CEO of COVER Corp.

  Originally focusing on the development and creation of AR and VR technologies, in 2017, COVER Corp. created the talent agency, hololive production.

  He likes to watch TV and YouTube before going to bed, sometimes falling asleep on the sofa.

  The name YAGOO originated from one of Roboco's streams, where Subaru misread "Tanigo" as "Yagoo".
  """

  def ask(update) do
    Logger.info("Command /ask")

    {:ok, _} =
      send_message("What would you like to know?",
        reply_markup: %Model.InlineKeyboardMarkup{
          inline_keyboard: [
            [
              %{
                callback_data: "/ask what-is-hololive",
                text: "What is Hololive?"
              },
              %{
                callback_data: "/ask what-is-cover",
                text: "What is COVER?"
              }
            ],
            [
              %{
                callback_data: "/ask who-is-yagoo",
                text: "Who is YAGOO?"
              },
              %{
                callback_data: "/ask why-digital-avatars",
                text: "Why digital avatars?"
              }
            ]
          ]
        }
      )
  end

  def ask_query_command(update) do
    Logger.info("Callback Query Command /ask")

    case update.callback_query.data do
      "/ask what-is-hololive" ->
        send_message(@about_hololive)

      "/ask what-is-cover" ->
        send_message(@about_cover)

      "/ask who-is-yagoo" ->
        send_message(@about_yagoo)

      "/ask why-digital-avatars" ->
        send_message(
          "Various reasons. It's fun, it's unique, and it provides a degree of anonymity.
         It's also to showcase how technology has advanced over recent years.
         The idea of being a cartoon character in real-time was essentially unheard of even five years ago."
        )
    end
  end
end
