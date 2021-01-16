defmodule Holobot.Helpers do
  @moduledoc """
  Holobot helpers module.

  Functions that are not strictly related to Holofans or Telegram domains.
  """

  @about_cover "COVER corp. is a cutting edge 2D entertainment company. It is the parent company of Hololive Production."
  @about_hololive "Hololive Production is a virtual YouTuber talent agency."
  @about_yagoo """
  YAGOO (Motoaki Tanigo) is the CEO of COVER Corp.

  Originally focusing on the development and creation of AR and VR technologies, in 2017, COVER Corp. created the talent agency, hololive production.

  He likes to watch TV and YouTube before going to bed, sometimes falling asleep on the sofa.

  The name YAGOO originated from one of Roboco's streams, where Subaru misread "Tanigo" as "Yagoo".
  """

  @type question_type() :: :concept_compl | :verification | :quantification

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
      "UCyl1z3jo3XHR1riLFKG5UAg" => "🔎"
    }

    Map.get(channel_emoji, yt_channel_id, "")
  end

  @spec table_exists?(any) :: boolean
  def table_exists?(table) do
    require Memento

    table in Memento.system(:local_tables)
  end

  @spec tokenize_msg(binary) :: [binary]
  def tokenize_msg(msg_text) when is_binary(msg_text) do
    msg_text
    |> String.replace(~r/[[:punct:]]/, "")
    |> String.downcase()
    |> String.split()
  end

  @doc """
  Parse a tokenized Telegram message sentence and generate a response.
  """
  @spec parse(list(binary())) :: binary() | nil
  def parse(tokens) do
    # This is mostly just a placeholder dead simply NLP pipeline,
    # the idea is to possibly integrate a sophisticated cloud NLP service
    # like Amazon Lex in here to generate responses.
    if is_greeting?(tokens) do
      random_greeting()
    else
      # It is a question or anything else
      case classify_question_type(tokens) do
        :verification ->
          answer_y_n(tokens)

        :concept_compl ->
          define_concept(tokens)

        _ ->
          nil
      end
    end
  end

  defp define_concept(tokens) do
    cond do
      "hololive" in tokens -> @about_hololive
      "yagoo" in tokens -> @about_yagoo
      "cover" in tokens -> @about_cover
      true -> "I don't know who or what that is."
    end
  end

  defp answer_y_n(tokens) do
    cond do
      "you" in tokens and "real" in tokens ->
        "Of course I am!"

      "anyone" in tokens and "streaming" in tokens and "now" in tokens ->
        "Someone might be streaming right now..."

      true ->
        "I can neither confirm nor deny that."
    end
  end

  defp is_greeting?(tokens) do
    greetings = ["hello", "こんにちは", "hi"]

    Enum.any?(tokens, &Enum.member?(greetings, &1))
  end

  defp random_greeting() do
    greetings = [
      "Hello!",
      "How you doing?",
      "Hey!"
    ]

    Enum.random(greetings)
  end

  @spec classify_question_type(list(binary())) :: question_type()
  defp classify_question_type(tokens) do
    cond do
      Enum.any?(tokens, &Enum.member?(["what", "who", "where", "when"], &1)) ->
        :concept_compl

      "is" in tokens or "are" in tokens ->
        :verification

      "how" in tokens and ("much" in tokens or "many" in tokens) ->
        :quantification

      true ->
        nil
    end
  end
end
