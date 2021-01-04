defmodule Holobot.Holofans.CacheServer do
  @moduledoc """
  Holofans API caching server.
  """
  use GenServer

  require Logger
  require Memento

  alias Holobot.Holofans.Video

  @video_cache_limit 10

  def start_link(init_args \\ []) do
    # you may want to register your server with `name: __MODULE__`
    # as a third argument to `start_link`
    GenServer.start_link(__MODULE__, [init_args])
  end

  def init(_args) do
    {:ok, :initial_state}
  end

  def handle_cast({:update}) do
    # Do fetching from API and writing to cache

    # Wait for 5min before calling update()
    # Call update

    {:noreply, :ok}
  end

  # Client

  defp update() do
    GenServer.cast(__MODULE__, :update)
  end

  # helpers

  defp setup_tables() do
    Memento.Table.create!(Video)
    # Create the ETS/Mnesia tables
  end

  def get_videos() do
    get_videos([], 0)
  end

  def get_videos(videos, offset) when is_list(videos) and offset > @video_cache_limit do
    videos
  end

  def get_videos(videos, offset) when is_list(videos) do
    holofans_api_base = Application.fetch_env!(:holobot, :holofans_api)
    path = "/v1/videos"
    step = 5
    params = %{limit: step, offset: offset}

    url =
      holofans_api_base
      |> URI.parse()
      |> URI.merge(path)
      |> Map.put(:query, URI.encode_query(params))
      |> URI.to_string()

    res =
      case HTTPoison.get(url) do
        {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
          {:ok, decoded} = Jason.decode(body)
          decoded

        {:ok, %HTTPoison.Response{status_code: 404}} ->
          Logger.warning("Resource not found")

        {:error, %HTTPoison.Error{reason: reason}} ->
          Logger.error(reason)
      end

    get_videos(res["videos"] ++ videos, offset + step)
  end
end
