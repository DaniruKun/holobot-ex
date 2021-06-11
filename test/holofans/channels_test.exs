defmodule Holobot.Holofans.ChannelsTest do
  use ExUnit.Case, async: false

  import Mock

  alias Holobot.Holofans.{Channel, Channels}

  @valid_resp_body "{\"count\":2,\"total\":63,\"channels\":[{\"id\":5,\"yt_channel_id\":\"UC0TXe_LYZ4scaW2XMyi5_kw\",\"bb_space_id\":null,\"name\":\"AZKi Channel\",\"description\":\"AZKiです。音楽を通して一人一人と繋がって\\n一緒に世界を創って行きたくて転生しました。\\n\\nチャンネル登録や、動画や生放送で\\nいっぱいコメントしてくれると嬉しいです！\\n\\nタグ #AZKi\\nファンアート #AZKiART\\nファンの名前 #開拓者\\n\\n---------------------------------------------\\n\\n■Twitter■\\nhttps://twitter.com/AZKi_VDiVA\\n\\n■Youtube■\\nhttp://ur0.work/Nu8M\\n\\n■オフィシャルストア■\\nhttps://store.azki-official.com/\\n\\n■カバー株式会社■\\nhttp://cover-corp.com/\\n\\n---------------------------------------------\",\"photo\":\"https://yt3.ggpht.com/ytc/AAUvwnikIko_2aD91x5MOTT2tETPe4R-7ozz6eIige3z=s800-c-k-c0x00ffffff-no-rj\",\"published_at\":\"2018-11-05T12:16:27.000Z\",\"twitter_link\":\"AZKi_VDiVA\",\"view_count\":11447552,\"subscriber_count\":276000,\"video_count\":148,\"video_original\":169},{\"id\":19,\"yt_channel_id\":\"UCAoy6rzhSf4ydcYjJw3WoVg\",\"bb_space_id\":null,\"name\":\"Airani Iofifteen Channel hololive-ID\",\"description\":\"Nyo! 🎨\\n\\nIofi - Bukan Anak Alien biasa di sini~ Multilingual Vtuber asal luar angkasa dan sedang kuliah jurusan DKV di Bumi \\n\\nMohon bantuannya dan jangan lupa nyalakan telepathy kalian ya 人´∀｀)\\n\\n【Support  & Jajanin Iofi】\\nhttps://streamlabs.com/airaniiofifteenchannelhololive-id\\n\\n【Twitter】\\nTwitter → @airaniiofifteen\\nhttps://twitter.com/airaniiofifteen \\n【Instagram】\\nhttps://www.instagram.com/airani_iofifteen/\\n【Facebook Page】\\nhttps://www.facebook.com/Airani-Iofifteen-hololive-ID-111788127142691/\\n\\n【Mitsuki-MAMA】\\nYano Mitsuki (夜ノみつき)\\nhttps://twitter.com/mituk1\\n\\n\\n【Official cover website】\\nhttp://cover-corp.com/\\n【Official Twitter Hololive Indonesia】\\nhttps://twitter.com/hololive_Id\\n【Official Facebook Hololive Indonesia】\\nhttps://www.facebook.com/Hololive-Indonesia-108806367277672/\\n\\n【Hololive Indonesia】\\nAyunda Risu (アユンダ・リス)\\nhttps://www.youtube.com/channel/UCOyYb1c43VlX9rc_lT6NKQw\\nMoona Hoshinova (ムーナ・ホシノヴァ)\\nhttps://t.co/nwIx1O5CXU?amp=1\\nAirani Iofifteen (アイラニ・イオフィフティーン)\\nhttps://www.youtube.com/cha\",\"photo\":\"https://yt3.ggpht.com/ytc/AAUvwnh4NDjjjUAfPj8Aa4kjyQb4C85KzMWobSCaso-8=s800-c-k-c0x00ffffff-no-rj\",\"published_at\":\"2020-03-03T07:35:07.178Z\",\"twitter_link\":\"airaniiofifteen\",\"view_count\":5774051,\"subscriber_count\":254000,\"video_count\":139,\"video_original\":148}]}"

  # setup_with_mocks([
  #   {HTTPoison, [],
  #    [get: fn _url -> {:ok, %HTTPoison.Response{status_code: 200, body: @valid_resp_body}} end]}
  # ]) do
  #   start_supervised!(Channels)
  #   Process.sleep(1000)
  #   :ok
  # end

  # test "get_channels/0 returns a list of all channels" do

  # end

  describe "init" do
    test "init/1 sets up mnesia and returns continue" do
      {:ok, %{}, {:continue, :update}} = Channels.init("some args")

      assert Memento.system(:tables) |> Enum.member?(Channel)
    end
  end
end
