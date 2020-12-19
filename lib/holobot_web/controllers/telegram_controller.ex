defmodule HolobotWeb.TelegramController do
  use HolobotWeb, :controller
  import Logger

  def update(conn, params) do
    info("Received update from Telegram", [])
  end

end
