defmodule HolobotWeb.HelloController do
  use HolobotWeb, :controller

  def world(conn, %{"name" => name}) do
    render(conn, "world.html", name: name)
  end
end
