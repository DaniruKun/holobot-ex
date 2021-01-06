defmodule Holobot.Holofans.VideoTest do
  @moduledoc false
  use ExUnit.Case, async: true

  alias Holobot.Holofans.Video

  test "build_record/1 returns a correctly built Video struct" do
    expected = %Video{
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

    vid = %{
      "bb_video_id" => nil,
      "channel" => %{
        "bb_space_id" => nil,
        "description" =>
          "人前に出ることが苦手な魔界学校に所属のネクロマンサー(死霊使い)の少女。ひとりぼっちが嫌なので死霊や屍とおしゃべりをしている。\n\n＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝\n\nホロライブ公式YouTubeチャンネルでもオリジナルコンテンツ配信中！▷ https://www.youtube.com/channel/UCJFZiqLMntJufDCHc6bQixg\nホロライブ公式Twitter▷ https://twitter.com/hololivetv\nホロライブ公式サイト▷ https://www.hololive.tv/\n\n＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝",
        "id" => 27,
        "name" => "Watson Amelia Ch. hololive-EN",
        "photo" =>
          "https://yt3.ggpht.com/ytc/AAUvwngKVHYXNDzaEG9KIXm9lK0nBxHkA-NxlE88dLtl=s800-c-k-c0x00ffffff-no-rj",
        "published_at" => "2019-07-03T06:34:35.000Z",
        "subscriber_count" => 863_000,
        "twitter_link" => "watsonameliaen",
        "video_count" => 152,
        "view_count" => 37_070_455,
        "yt_channel_id" => "UCyl1z3jo3XHR1riLFKG5UAg"
      },
      "duration_secs" => nil,
      "id" => 6_640_351,
      "is_captioned" => false,
      "is_uploaded" => false,
      "live_end" => nil,
      "live_schedule" => "2021-01-07T01:00:00.000Z",
      "live_start" => nil,
      "published_at" => nil,
      "status" => "upcoming",
      "thumbnail" => nil,
      "title" => "【BIRTHDAY STREAM】CAKE + a Special Announcement",
      "yt_video_key" => "_AbZB1uuVjA"
    }

    assert expected == Video.build_record(vid)
  end
end
