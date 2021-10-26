defmodule HelpersTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias Holobot.Helpers
  alias Holodex.Model.Channel

  @valid_channel %Channel{
    name: "Watson Amelia Ch. hololive-EN",
    id: "UCyl1z3jo3XHR1riLFKG5UAg"
  }

  defp channel_fixture(attrs \\ %{}) do
    Map.merge(@valid_channel, attrs)
  end

  describe "channel emojis" do
    test "get_channel_emoji/1 returns the correct YT channel emoji when channel is matched" do
      channel = channel_fixture()

      assert "🔎" = Helpers.get_channel_emoji(channel.id)
    end

    test "get_chanel_emoji/1 returns empty binary when YT channel is not found" do
      channel = channel_fixture(%{id: "some_fake_id"})

      assert "" = Helpers.get_channel_emoji(channel.id)
    end
  end

  describe "tokenizer" do
    test "tokenize_msg/1 returns correct tokens for message with punctuation and multiple words" do
      msg_text = "How are you doing?"

      assert ["how", "are", "you", "doing"] = Helpers.tokenize_msg(msg_text)
    end
  end
end
