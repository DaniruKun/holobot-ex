defmodule Holobot.Helpers do
  @moduledoc """
  Holobot helpers module.

  Functions that are not strictly related to Holofans or Telegram domains.
  """

  @spec tokenize(binary) :: [binary]
  defdelegate tokenize(text), to: __MODULE__, as: :tokenize_msg

  @doc """
  Get the emoji corresponding to a Hololive channel by the YT channel ID.
  Returns empty binary if not found.
  """
  @spec get_channel_emoji(binary()) :: binary()
  def get_channel_emoji(yt_channel_id) do
    channel_emoji = %{
      # 0th Generation
      "UCp6993wxpyDPHUpavwDFqgg" => "🐻",
      "UCDqI2jOz0weumE8s7paEk6g" => "🤖",
      "UC-hM6YJuNYVAmUWxeIr9FeA" => "🌸",
      "UC5CwaMl1eIgY8h02uZw7u8A" => "☄️",
      "UC0TXe_LYZ4scaW2XMyi5_kw" => "⚒️",
      # 1st Generation
      "UCD8HOxPs4Xvsm8H0ZxXGiBw" => "🌟",
      "UC1CfXB_kRs3C-zaeTG3oGyg" => "♥️",
      "UCdn5BQ06XqgXoAxIhbqw5Rg" => "🌽",
      "UCQ0UDLQCjY0rmuxCDE38FGg" => "🏮",
      "UCLbtM3JZfRTg8v2KGag-RMw" => "🍎",
      # 2nd Generation
      "UC1opHUrw8rvnsadT-iGp7Cg" => "⚓",
      "UCXTpFs_3PqI41qX2d9tL2Rw" => "🌙",
      "UC7fk0CB07ly8oSl0aqKkqFg" => "😈",
      "UC1suqwovbL1kzsoaZgFZLKg" => "💋",
      "UCvzGlP9oQwU--Y0r9id_jnA" => "🚑",
      # Hololive GAMERS
      "UCp-5t9SrOQwXMU7iIjQfARg" => "🌲",
      "UCvaTdHTWBGv3MKj3KVqJVCw" => "🍙",
      "UChAnqc_AY5_I3Px5dig3X1Q" => "🥐",
      # 3rd Generation
      "UC1DCedRgGHBdm81E1llLhOQ" => "👯",
      "UCl_gCybOJRIgOXw6Qb4qJzQ" => "🦋",
      "UCvInZx9h3jC2JzsIzoOebWg" => "🔥",
      "UCdyqAaZDKHXg4Ahi7VENThQ" => "⚔️",
      "UCCzUftO8KOVkV4wQG1vkUvg" => "🏴‍☠️",
      # 4th Generation
      "UCZlDXzGoo7d44bwdNObFacg" => "💫",
      "UCS9uQI-jC3DE0L4IpXyvr6w" => "🐉",
      "UCqm3BQLlJfvkTsX_hvm0UmA" => "🐏",
      "UC1uv2Oq6kNxgATlCiez59hw" => "👾",
      "UCa9Y57gfeY0Zro_noHRVrnw" => "🍬",
      # 5th Generation
      "UCFKOVgVbGmX65RxO3EtH3iw" => "☃️",
      "UCAWSyEs_Io8MtpY3m-zqILA" => "🥟",
      "UCUKD-uaobj9jiqB-VXt71mA" => "♌",
      "UCK9V2B22uJYu3N7eR_BT9QA" => "🎪",
      # Holostars
      "UC6t3-_N8A6ME1JShZHHqOMw" => "🌺",
      "UCZgOv3YDEs-ZnZWDYVwJdmA" => "🎸",
      "UCKeAhJvy8zgXWbh9duVjIaQ" => "🍕",
      "UC9mf_ZVpouoILRY9NUIaK-w" => "⚙️",
      "UCNVEsYbiZjH5QLmGeSgTSzg" => "🎭",
      "UCGNI4MENvnsymYjKiZwv9eg" => "🦔",
      "UCANDOlYTJT7N5jlRC3zfzVA" => "🍷",
      "UChSvpZYRPh0FvG4SJGSga3g" => "🟣",
      "UCwL7dgTxKo8Y4RFIKWaf8gA" => "🐃",
      # HoloID
      "UCOyYb1c43VlX9rc_lT6NKQw" => "🐿",
      "UCP0BspO_AMEe3aQqqpo89Dg" => "🔮",
      "UCAoy6rzhSf4ydcYjJw3WoVg" => "🎨",
      "UCYz_5n-uDuChHtLo7My1HnQ" => "🧟‍♀️",
      "UC727SQYUvx5pDDGQpTICNWg" => "🍂",
      "UChgTyjG-pdNvxxhdsXfHQ5Q" => "🦚",
      # HololiveEN
      "UCL_qhgtOy0dy1Agp8vkySQg" => "💀",
      "UCHsx4Hqa-1ORjQTh9TYDhww" => "🐔",
      "UCMwGHR0BTZuLsmjY_NT5Pwg" => "🐙",
      "UCoSrY_IQQVpmIRZ9Xf-y93g" => "🔱",
      "UCyl1z3jo3XHR1riLFKG5UAg" => "🔎",
      "UC8rcEBzJSleTkf_-agPM20g" => "💎",
      "UCsUj0dszADCGbF3gNrQEuSQ" => "🪐",
      "UC3n5uGu18FoCy23ggWWp8tA" => "🪶",
      "UCmbs8T6MWqUHP1tIQvSgKrg" => "⏳",
      "UCO_aKKYxn4tvrqPjcTzZ6EQ" => "🌿",
      "UCgmPnx-EEeOrZSg5Tiw7ZRQ" => "🎲",
      # HoloX
      "UCENwRMx5Yh42zWpzURebzTw" => "🛸💜",
      "UCs9_O1tRPMQTHQ-N_L6FU2g" => "🥀",
      "UC6eWCld0KwmyHFbAqK3V-Rw" => "🧪",
      "UCIBY1ollUsauvVi4hW4cumw" => "🎣",
      "UC_vMYWcDjmfdpH6r4TTn1MQ" => "🍃"	
    }

    Map.get(channel_emoji, yt_channel_id, "")
  end

  @doc """
  Checks if a given Mnesia table exists.
  """
  @spec table_exists?(any) :: boolean
  def table_exists?(table) do
    require Memento

    table in Memento.system(:local_tables)
  end

  @doc """
  Splits and cleans a message binary into lowercase, non-punctuated tokens.
  """
  @spec tokenize_msg(binary) :: [binary]
  def tokenize_msg(msg_text) when is_binary(msg_text) or is_bitstring(msg_text) do
    msg_text
    |> String.replace(~r/[[:punct:]]/, "")
    |> String.downcase()
    |> String.split()
  end
end
