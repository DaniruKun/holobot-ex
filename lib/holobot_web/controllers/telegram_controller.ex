defmodule HolobotWeb.TelegramController do
  use HolobotWeb, :controller

  require Logger

  def update(conn, params) do
    Logger.info("Received update from Telegram", [])

    #decoded_body = Jason.decode!(body)
    text(conn, "Ok")
  end
end
