defmodule MessagesTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias Holobot.Telegram.Messages

  import Mock

  @valid_live %{
    "bb_video_id" => nil,
    "channel" => %{
      "bb_space_id" => nil,
      "id" => 199_075,
      "name" => "Ninomae Ina'nis Ch. hololive-EN",
      "photo" =>
        "https://yt3.ggpht.com/ytc/AAUvwng37V0l-NwF3bu7QA4XmOP5EZFwk5zJE-78OHP9=s800-c-k-c0x00ffffff-no-rj",
      "published_at" => "2020-07-16T06:23:05.258Z",
      "subscriber_count" => 656_000,
      "twitter_link" => "ninomaeinanis",
      "video_count" => 87,
      "view_count" => 19_773_769,
      "yt_channel_id" => "UCMwGHR0BTZuLsmjY_NT5Pwg"
    },
    "id" => 78_244_855,
    "live_end" => nil,
    "live_schedule" => "2020-12-29T22:00:00.000Z",
    "live_start" => nil,
    "live_viewers" => 15_000,
    "status" => "live",
    "thumbnail" => nil,
    "title" => "【Minecraft】 exPLOSION!",
    "yt_video_key" => "fDDyY3yq4OE"
  }

  @valid_chan %{
    "bb_space_id" => nil,
    "description" => "こんぺこ！こんぺこ！こんぺこー！\nホロライブ3期生の兎田ぺこら（Usada Pekora)ぺこ👯‍♀️",
    "id" => 36,
    "name" => "Pekora Ch. 兎田ぺこら",
    "photo" =>
      "https://yt3.ggpht.com/ytc/AAUvwnjvkyPGzOmEXZ34mEFPlwMKTbCDl1ZkQ_HkxY-O5Q=s800-c-k-c0x00ffffff-no-rj",
    "published_at" => "2019-07-03T06:28:25.000Z",
    "subscriber_count" => 1_110_000,
    "twitter_link" => "usadapekora",
    "video_count" => 318,
    "view_count" => 95_176_833,
    "yt_channel_id" => "UC1DCedRgGHBdm81E1llLhOQ"
  }

  defp lives_fixture(attrs \\ %{}) do
    [Enum.into(attrs, @valid_live)]
  end

  defp channels_fixture(attrs \\ %{}) do
    [Enum.into(attrs, @valid_chan)]
  end

  describe "stream messages" do
    test_with_mock(
      "build_live_msg/1 builds a msg of live channels when stream hasn't started yet",
      DateTime,
      [:passthrough],
      utc_now: fn -> ~U[2020-12-29 21:00:00.000Z] end
    ) do
      # We mock a current UTC time that is one hour before scheduled start
      lives = lives_fixture()

      live_msg = Messages.build_live_msg(lives)

      expected_msg =
        "🔴 *Live channels*\n\n🐙Ninomae Ina'nis Ch. hololive-EN\nStarts in *60* minutes\n[【Minecraft】 exPLOSION!](https://youtu.be/fDDyY3yq4OE)\n\n"

      assert expected_msg == live_msg
    end

    test_with_mock(
      "build_live_msg/1 builds a msg of live channels when stream has already started",
      DateTime,
      [:passthrough],
      utc_now: fn -> ~U[2020-12-29 22:30:00.000Z] end
    ) do
      lives = lives_fixture(%{"live_start" => "2020-12-29T22:00:00.000Z"})

      live_msg = Messages.build_live_msg(lives)

      expected_msg =
        "🔴 *Live channels*\n\n🐙Ninomae Ina'nis Ch. hololive-EN\nStarted *30* minutes ago\n[【Minecraft】 exPLOSION!](https://youtu.be/fDDyY3yq4OE)\n\n"

      assert expected_msg == live_msg
    end
  end

  describe "channel messages" do
    test "build_channel_list_msg/1 returns correct channel list message" do
      channels = channels_fixture()

      expected = """
      *Channels*

      👯[Pekora Ch. 兎田ぺこら](https://www.youtube.com/channel/UC1DCedRgGHBdm81E1llLhOQ)
      1110K Subscribers
      [Twitter](https://twitter.com/usadapekora)

      """

      assert expected == Messages.build_channels_list_msg(channels)
    end
  end
end
