defmodule HolobotWeb.TelegramController do
  use HolobotWeb, :controller

  require Logger

  def update(conn, _params) do
    Logger.info("Received update from Telegram", [])
    {:ok, body, conn} = Plug.Conn.read_body(conn, length: 100_000)
    decoded_body = Jason.decode!(body)
    Logger.info(decoded_body, [])
    text(conn, "Ok")
  end
end
