defmodule HelpersTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias Holobot.Helpers
  alias Holobot.Holofans.Channel

  @valid_channel %Channel{
    name: "Watson Amelia Ch. hololive-EN",
    yt_channel_id: "UCyl1z3jo3XHR1riLFKG5UAg"
  }

  defp channel_fixture(attrs \\ %{}) do
    Map.merge(@valid_channel, attrs)
  end

  describe "channel emojis" do
    test "get_channel_emoji/1 returns the correct YT channel emoji when channel is matched" do
      channel = channel_fixture()

      assert "🔎" = Helpers.get_channel_emoji(channel.yt_channel_id)
    end

    test "get_chanel_emoji/1 returns empty binary when YT channel is not found" do
      channel = channel_fixture(%{yt_channel_id: "some_fake_id"})

      assert "" = Helpers.get_channel_emoji(channel.yt_channel_id)
    end
  end

  describe "tokenizer" do
    test "tokenize_msg/1 returns correct tokens for message with punctuation and multiple words" do
      msg_text = "How are you doing?"

      assert ["how", "are", "you", "doing"] = Helpers.tokenize_msg(msg_text)
    end
  end

  describe "parser" do
    test "parse/1 returns a greeting when a greeting is given" do
      tokens = ["hello", "a-chan"]

      response = Helpers.parse(tokens)

      assert response in ["Hello!", "How you doing?", "Hey!"]
    end

    test "parse/1 correctly answers: Who is YAGOO?" do
      tokens = ["who", "is", "yagoo"]

      response = Helpers.parse(tokens)

      assert response =~ "YAGOO (Motoaki Tanigo) is the CEO of COVER Corp"
    end

    test "parse/1 correctly answers: What is Hololive?" do
      tokens = ["what", "is", "hololive"]

      assert "Hololive Production is a virtual YouTuber talent agency." = Helpers.parse(tokens)
    end

    test "parse/1 returns nil when unanswerable message" do
      tokens = ["Some", "kind", "of", "message"]

      assert nil == Helpers.parse(tokens)
    end
  end
end
