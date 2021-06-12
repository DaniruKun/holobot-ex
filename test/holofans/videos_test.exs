defmodule Holobot.Holofans.VideosTest do
  use ExUnit.Case, async: false

  alias Holobot.Holofans.{Video, Videos}

  describe "init" do
    test "init/1 sets up mnesia table and returns continue" do
      {:ok, %{}, {:continue, :update}} = Videos.init("some args")

      assert Memento.system(:tables) |> Enum.member?(Video)
    end
  end
end
