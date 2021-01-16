defmodule MessagesTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias Holobot.Telegram.Messages
  alias Holobot.Holofans.Video
  alias Holobot.Holofans.Channel
  alias Nadia.Model.InlineQueryResult.Article

  import Mock

  @valid_vid %Video{
    __meta__: Memento.Table,
    channel: %{
      "name" => "Watson Amelia Ch. hololive-EN",
      "subscriber_count" => 863_000,
      "twitter_link" => "watsonameliaen",
      "video_count" => 152,
      "view_count" => 37_070_455,
      "yt_channel_id" => "UCyl1z3jo3XHR1riLFKG5UAg"
    },
    duration_secs: nil,
    is_captioned: false,
    is_uploaded: false,
    live_end: nil,
    live_schedule: "2021-01-07T01:00:00.000Z",
    live_start: nil,
    live_viewers: nil,
    status: "upcoming",
    title: "【BIRTHDAY STREAM】CAKE + a Special Announcement",
    yt_video_key: "_AbZB1uuVjA"
  }

  @valid_chan %Channel{
    name: "Pekora Ch. 兎田ぺこら",
    description: "Konpeko konpeko konpekooo",
    subscriber_count: 1_110_000,
    twitter_link: "usadapekora",
    video_count: 318,
    view_count: 95_176_833,
    yt_channel_id: "UC1DCedRgGHBdm81E1llLhOQ",
    photo: "https://yt3.ggpht.com/ytc/photo-id"
  }

  defp video_fixture(attrs \\ %{}) do
    [Map.merge(@valid_vid, attrs)]
  end

  defp channels_fixture() do
    [@valid_chan]
  end

  describe "stream messages" do
    test_with_mock(
      "build_msg_for_status/2 builds a msg of upcoming channels when stream hasn't started yet",
      DateTime,
      [:passthrough],
      utc_now: fn -> ~U[2021-01-07 00:30:00.000Z] end
    ) do
      # We mock current UTC time that is 30 min before scheduled start
      vids = video_fixture()

      msg = Messages.build_msg_for_status(vids, :upcoming)

      expected_msg =
        "⏰ *Upcoming streams*\n\n🔎Watson Amelia Ch. hololive-EN\nStarts in *30 minutes*\n[【BIRTHDAY STREAM】CAKE + a Special Announcement](https://youtu.be/_AbZB1uuVjA)\n\n"

      assert expected_msg == msg
    end

    test_with_mock(
      "build_msg_for_status/2 builds a msg of live channels when stream has already started for status :live",
      DateTime,
      [:passthrough],
      utc_now: fn -> ~U[2021-01-07 01:30:00.000Z] end
    ) do
      # We mock the current UTC time to be 30 min after stream start

      vids = video_fixture(%{live_start: "2021-01-07T01:00:00.000Z"})

      msg = Messages.build_msg_for_status(vids, :live)

      expected_msg =
        "🔴 *Live channels*\n\n🔎Watson Amelia Ch. hololive-EN\nStarted *30 minutes* ago\n[【BIRTHDAY STREAM】CAKE + a Special Announcement](https://youtu.be/_AbZB1uuVjA)\n\n"

      assert expected_msg == msg
    end

    test_with_mock(
      "build_msg_for_status/2 builds a msg of live channels when stream has already started for status :live more than an hour ago",
      DateTime,
      [:passthrough],
      utc_now: fn -> ~U[2021-01-07 02:30:00.000Z] end
    ) do
      vids = video_fixture(%{live_start: "2021-01-07T01:00:00.000Z"})

      msg = Messages.build_msg_for_status(vids, :live)

      expected_msg = """
      🔴 *Live channels*

      🔎Watson Amelia Ch. hololive-EN
      Started *1h 30 minutes* ago
      [【BIRTHDAY STREAM】CAKE + a Special Announcement](https://youtu.be/_AbZB1uuVjA)\n
      """

      assert expected_msg == msg
    end
  end

  describe "channel messages" do
    test "build_channel_list_msg/1 returns correct channel list message when subs >= 1M" do
      channels = channels_fixture()

      expected = """
      *Channels*

      👯[Pekora Ch. 兎田ぺこら](https://www.youtube.com/channel/UC1DCedRgGHBdm81E1llLhOQ)
      1.11M Subscribers
      [Twitter](https://twitter.com/usadapekora)

      """

      assert ^expected = Messages.build_channels_list_msg(channels)
    end
  end

  describe "inline_articles" do
    test "build_live_articles_inline/1 returns a correct list of Articles from a list of lives" do
      vids = video_fixture()

      articles = Messages.build_live_articles_inline(vids)

      expected = [
        %Article{
          id: "_AbZB1uuVjA",
          title: "【BIRTHDAY STREAM】CAKE + a Special Announcement",
          thumb_url: "https://img.youtube.com/vi/_AbZB1uuVjA/sddefault.jpg",
          thumb_width: 640,
          thumb_height: 480,
          description: "Watson Amelia Ch. hololive-EN",
          url: "https://youtu.be/_AbZB1uuVjA",
          input_message_content: %{
            message_text: "https://youtu.be/_AbZB1uuVjA"
          }
        }
      ]

      assert ^expected = articles
    end

    test "build_chanel_articles_inline returns a correct list of Articles from a list of channels" do
      channels = channels_fixture()

      articles = Messages.build_channel_articles_inline(channels)

      expected = [
        %Article{
          id: "UC1DCedRgGHBdm81E1llLhOQ",
          title: "Pekora Ch. 兎田ぺこら",
          thumb_url: "https://yt3.ggpht.com/ytc/photo-id",
          thumb_width: 600,
          thumb_height: 600,
          description: "1.11M Subscribers",
          url: "https://www.youtube.com/channel/UC1DCedRgGHBdm81E1llLhOQ",
          input_message_content: %{
            message_text: """
            <b>Pekora Ch. 兎田ぺこら</b>
            <a href="https://yt3.ggpht.com/ytc/photo-id">Photo</a>

            <a href="https://www.youtube.com/channel/UC1DCedRgGHBdm81E1llLhOQ">Youtube</a> <a href="https://twitter.com/usadapekora">Twitter</a>

            Konpeko konpeko konpekooo
            """,
            parse_mode: "HTML"
          }
        }
      ]

      assert ^expected = articles
    end
  end
end
