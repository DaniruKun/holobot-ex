defmodule HelpersTest do
  @moduledoc false
  use ExUnit.Case, async: true

  import Holobot.Helpers

  @valid_channel %{
    "id" => 199_077,
    "name" => "Watson Amelia Ch. hololive-EN",
    "published_at" => "2020-07-16T06:23:05.258Z",
    "yt_channel_id" => "UCyl1z3jo3XHR1riLFKG5UAg"
  }

  defp channel_fixture(attrs \\ %{}) do
    Map.merge(@valid_channel, attrs)
  end

  describe "channel emojis" do
    test "get_channel_emoji/1 returns the correct YT channel emoji when channel is matched" do
      channel = channel_fixture()

      assert "🔎" = Holobot.Helpers.get_channel_emoji(channel)
    end

    test "get_chanel_emoji/1 returns empty binary when YT channel is not found" do
      channel = channel_fixture(%{"yt_channel_id" => "some_fake_id"})

      assert "" = Holobot.Helpers.get_channel_emoji(channel)
    end

    test "get_channel_emoji/1 raises FunctionClauseError when yt_channel_id key is missing from channel" do
      assert_raise FunctionClauseError, fn ->
        Holobot.Helpers.get_channel_emoji(%{})
      end
    end
  end
end
