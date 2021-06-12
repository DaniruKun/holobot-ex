defmodule Holobot.Holofans.Channels do
  @moduledoc """
  Holofans channels caching server and client API module.
  """

  use GenServer, shutdown: 10_000

  require Logger
  require Memento

  alias Holobot.Holofans.Channel

  require Logger

  @cache_update_interval 3_600_000

  def start_link(init_args \\ []) do
    Logger.info("Started Channels cache server")
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
    Logger.info("Performing initial channels cache")

    send(self(), :update)
    :timer.send_interval(@cache_update_interval, :update)

    {:noreply, state}
  end

  @impl true
  def handle_info(:update, _state) do
    Logger.info("Updating Channels cache")
    # Fetch and cache
    :ok = cache_channels!()

    {:noreply, :state}
  end

  # Client

  @doc """
  Get a list of all channels.
  """
  @spec get_channels :: list(Channel.t())
  def get_channels() do
    Memento.transaction!(fn ->
      Memento.Query.all(Channel)
    end)
  end

  @doc """
  Get a channel by its Youtube channel ID.
  """
  @spec get_channel(binary()) :: Channel.t() | nil
  def get_channel(yt_channel_id) do
    Memento.transaction!(fn ->
      Memento.Query.read(Channel, yt_channel_id)
    end)
  end

  @spec get_channels_top_subs(integer) :: [Channel.t()]
  def get_channels_top_subs(limit \\ 10) do
    get_channels() |> Enum.sort_by(& &1.subscriber_count, :desc) |> Enum.take(limit)
  end

  @spec get_channels_top_views(integer) :: [Channel.t()]
  def get_channels_top_views(limit \\ 10) do
    get_channels() |> Enum.sort_by(& &1.view_count, :desc) |> Enum.take(limit)
  end

  @spec search(any, any) :: Stream.t()
  def search(channels, query \\ "") do
    Stream.filter(channels, fn channel ->
      String.contains?(channel.name |> String.downcase(), query)
    end)
  end

  # Helpers

  defp cache_channels!(step \\ 50) do
    filter = %{
      sort: "name",
      limit: step
    }

    try do
      %{"total" => total} = fetch_channels!(filter)

      if total > 0 do
        0..total
        |> Stream.filter(&(rem(&1, step) == 0))
        |> Enum.each(fn offset ->
          Logger.debug("Current offset: #{offset}")

          channels_chunk =
            filter
            |> Map.merge(%{offset: offset})
            |> fetch_channels!()
            |> Map.get("channels")
            |> Enum.map(&Channel.build_record/1)

          Memento.transaction!(fn ->
            for channel <- channels_chunk, do: Memento.Query.write(channel)
          end)

          Logger.info("Cached total of #{total} channels")
        end)
      end
    rescue
      RuntimeError -> "Error when caching channels!"
    end
  end

  defp setup_table() do
    if !Holobot.Helpers.table_exists?(Channel) do
      Logger.info("Setting up Mnesia table Channel")
      Memento.Table.create!(Channel)
    end
  end

  defp fetch_channels!(filter \\ %{}) do
    fetch_channel_resource("/v1/channels", filter)
  end

  defp fetch_channel_resource(path, params \\ %{}) do
    holofans_api_base = Application.fetch_env!(:holobot, :holofans_api)

    url =
      holofans_api_base
      |> URI.parse()
      |> URI.merge(path)
      |> Map.put(:query, URI.encode_query(params))
      |> URI.to_string()

    Logger.debug("Making request to URL: #{url}")

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
end
