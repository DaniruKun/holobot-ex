defmodule Holobot.Holofans.Videos do
  @moduledoc """
  Holofans videos caching server and client API module.
  """
  use GenServer

  require Logger
  require Memento

  alias Holobot.Holofans.Video

  @type video_status() :: :new | :live | :upcoming | :past | :missing

  @cache_limit 1000
  @cache_update_interval 300_000

  defdelegate get_airing, to: __MODULE__, as: :get_lives

  def start_link(init_args \\ []) do
    Logger.info("Started Videos cache server")
    setup_table()
    GenServer.start_link(__MODULE__, [init_args], name: __MODULE__)
  end

  @impl true
  def init(_args) do
    # Start the update loop
    update()
    {:ok, :initial_state}
  end

  @impl true
  def handle_cast(:update, _state) do
    Logger.info("Updating Videos cache")
    # Clear records
    :ok = Memento.Table.clear(Video)
    # Do fetching from API and writing to cache
    :ok = cache_videos!(:live)
    :ok = cache_videos!(:upcoming)

    Process.sleep(@cache_update_interval)
    update()

    {:noreply, :ok}
  end

  # Client

  @doc """
  Update the cache state.
  """
  @spec update(atom | pid | {atom, any} | {:via, atom, any}) :: :ok
  def update(pid \\ __MODULE__) do
    GenServer.cast(pid, :update)
  end

  @doc """
  Get a video by its Youtube video ID
  """
  @spec get_video(binary()) :: %Video{} | nil
  def get_video(yt_vid_key) do
    Memento.transaction!(fn ->
      Memento.Query.read(Video, yt_vid_key)
    end)
  end

  @doc """
  Get list of all videos.
  """
  @spec get_all_videos :: list(%Video{})
  def get_all_videos() do
    Memento.transaction!(fn ->
      Memento.Query.all(Video)
    end)
  end

  @doc """
  Get list of currently airing live streams.
  """
  @spec get_lives :: list(%Video{})
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
  @spec get_upcoming(boolean()) :: list(%Video{})
  def get_upcoming(free_chat \\ false) do
    guards = [
      {:==, :live_start, nil},
      {:==, :status, "upcoming"},
      {:==, :duration_secs, nil}
    ]

    res =
      Memento.transaction!(fn ->
        Memento.Query.select(Video, guards)
      end)

    if free_chat do
      res
    else
      # Remove free chat streams
      res |> Enum.filter(&is_not_free_chat?/1)
    end
  end

  # Helpers

  defp setup_table() do
    # Create the ETS/Mnesia tables
    Logger.info("Setting up Mnesia tables")
    Memento.Table.create!(Video)
  end

  @spec cache_videos!(Videos.video_status()) :: any()
  defp cache_videos!(status) do
    # video request chunk size, <= 50
    step = 50

    filters = %{
      limit: step,
      status: Atom.to_string(status)
    }

    try do
      %{"total" => total} = fetch_videos!(filters)

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

          videos_chunk =
            filters
            |> Map.merge(%{offset: offset})
            |> fetch_videos!()
            |> Map.get("videos")
            |> Enum.map(&Video.build_record/1)

          Memento.transaction!(fn ->
            for video <- videos_chunk, do: Memento.Query.write(video)
          end)
        end)

        Logger.info("Cached total of #{items_to_fetch} videos of status: #{status}")
      else
        Logger.info("Nothing to cache, skipping.")
        :ok
      end
    rescue
      RuntimeError -> "Error when caching videos of status: #{status}!"
    end
  end

  defp fetch_videos!(params \\ %{}) do
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
        {:ok, decoded} = Jason.decode(body)
        decoded

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        Logger.warning("Resource not found")

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.error(reason)
    end
  end

  defp is_not_free_chat?(vid) do
    res = vid.title |> String.downcase() |> String.contains?(["free", "chat"])
    !res
  end
end
