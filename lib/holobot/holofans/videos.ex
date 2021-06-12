defmodule Holobot.Holofans.Videos do
  @moduledoc """
  Holofans videos caching server and client API module.
  """
  use GenServer, shutdown: 10_000

  require Logger
  require Memento

  alias Holobot.Holofans.Video

  @type video_status() :: :new | :live | :upcoming | :past | :missing

  @cache_limit 1000
  @cache_update_interval 300_000

  @spec get_airing :: [Holobot.Holofans.Video.t()]
  defdelegate get_airing, to: __MODULE__, as: :get_lives

  def start_link(init_args \\ []) do
    Logger.info("Started Videos cache server")
    GenServer.start_link(__MODULE__, [init_args], name: __MODULE__)
  end

  @impl true
  def init(_args) do
    # Setup Mnesia table
    setup_table()
    {:ok, %{}, {:continue, :update}}
  end

  @impl true
  def handle_continue(:update, state) do
    Logger.info("Performing initial Videos cache")

    send(self(), :update)
    :timer.send_interval(@cache_update_interval, :update)

    {:noreply, state}
  end

  @impl true
  def handle_info(:update, _state) do
    Logger.info("Updating Videos cache")
    # Clear records
    :ok = Memento.Table.clear(Video)
    # Do fetching from API and writing to cache
    cache_videos!(:live)
    cache_videos!(:upcoming)

    {:noreply, %{}}
  end

  # Client

  @doc """
  Get a video by its Youtube video ID
  """
  @spec get_video(binary()) :: Video.t() | nil
  def get_video(yt_vid_key) do
    Memento.transaction!(fn ->
      Memento.Query.read(Video, yt_vid_key)
    end)
  end

  @doc """
  Get list of all videos.
  """
  @spec get_all_videos :: list(Video.t())
  def get_all_videos() do
    Memento.transaction!(fn ->
      Memento.Query.all(Video)
    end)
  end

  @doc """
  Get list of currently airing live streams.
  """
  @spec get_lives :: list(Video.t())
  def get_lives() do
    guards = [
      {:==, :live_end, nil},
      {:!=, :live_start, nil},
      {:==, :status, "live"}
    ]

    Memento.transaction!(fn ->
      Memento.Query.select(Video, guards)
    end)
  end

  @doc """
  Get list of upcoming streams.
  """
  @spec get_upcoming() :: list(Video.t())
  def get_upcoming() do
    guards = [
      {:==, :live_start, nil},
      {:==, :status, "upcoming"},
      {:==, :duration_secs, nil}
    ]

    Memento.transaction!(fn ->
      Memento.Query.select(Video, guards)
    end)
    |> Enum.filter(&is_not_free_chat?/1)
  end

  @doc """
  Get list of only free chat streams.
  """
  @spec get_free_chats :: [Video.t()]
  def get_free_chats() do
    guards = [
      {:==, :live_start, nil},
      {:==, :status, "upcoming"},
      {:==, :duration_secs, nil}
    ]

    Memento.transaction!(fn ->
      Memento.Query.select(Video, guards)
    end)
    |> Enum.filter(&is_free_chat?/1)
  end

  @doc """
  Search for a video by title. Returns a list of up to 10 results.
  """
  @spec search_query(binary()) :: list(Video.t())
  def search_query(query) do
    with {:ok, results} <- fetch_videos(%{limit: 10, title: query}) do
      results |> Map.get("videos")
    end
  end

  # Helpers

  defp setup_table() do
    if !Holobot.Helpers.table_exists?(Video) do
      # Create the ETS/Mnesia table
      Logger.info("Setting up Mnesia table Video")

      Memento.Table.create!(Video)
    end
  end

  @spec cache_videos!(video_status()) :: any()
  defp cache_videos!(status) do
    # video request chunk size, <= 50
    step = 50

    filters = %{
      limit: step,
      status: Atom.to_string(status),
      order: "asc",
      sort: "live_schedule"
    }

    try do
      {:ok, %{"total" => total}} = fetch_videos(filters)

      # Set number of total results to fetch
      items_to_fetch =
        cond do
          total >= @cache_limit -> @cache_limit
          total < @cache_limit -> total
        end

      if items_to_fetch > 0 do
        0..items_to_fetch
        |> Stream.filter(&(rem(&1, step) == 0))
        |> Enum.each(fn offset ->
          Logger.debug("Current offset: #{offset}")

          with {:ok, results} <- fetch_videos(Map.merge(filters, %{offset: offset})),
               {:ok, videos} <- Map.fetch(results, "videos"),
               videos_chunk <- Enum.map(videos, &Video.build_record/1) do
            Memento.transaction!(fn ->
              for video <- videos_chunk, do: Memento.Query.write(video)
            end)
          end
        end)

        Logger.info("Cached total of #{items_to_fetch} videos of status: #{status}")
      else
        Logger.info("Nothing to cache, skipping.")
      end
    rescue
      RuntimeError -> "Error when caching videos of status: #{status}!"
    end
  end

  defp fetch_videos(params \\ %{}) do
    holofans_api_base = Application.fetch_env!(:holobot, :holofans_api)
    path = "/v1/videos"

    url =
      holofans_api_base
      |> URI.parse()
      |> URI.merge(path)
      |> Map.put(:query, URI.encode_query(params))
      |> URI.to_string()

    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        Jason.decode(body)

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.warning("Resource not found")
        {:error, "Not found"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error(reason)
        {:error, reason}
    end
  end

  defp is_not_free_chat?(vid) do
    !is_free_chat?(vid)
  end

  defp is_free_chat?(vid) do
    vid.title |> String.downcase() |> String.contains?(["free", "chat"])
  end
end
