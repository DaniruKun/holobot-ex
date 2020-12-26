defmodule HolobotWeb.TelegramController do
  use HolobotWeb, :controller

  require Logger

  def update(conn, params) do
    Logger.info("Received update from Telegram", [])
    # %{"somekey" => "b"} is the form of params, just JSON payload in Map form
    IO.inspect(params)
    # Where we handle updates from telegram, destructure the message and pass the info along to the required modules
    text(conn, "Ok")
  end
end
