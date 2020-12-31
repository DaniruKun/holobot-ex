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

  defp lives_fixture(attrs \\ %{}) do
    [Enum.into(attrs, @valid_live)]
  end

  describe "messages" do
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
end
