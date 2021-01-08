defmodule Holobot.Holofans.Channels do
  @moduledoc """
  Holofans channels caching server and client API module.
  """

  use GenServer

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
    # Start the update loop
    setup_table()
    update()
    {:ok, :initial_state}
  end

  @impl true
  def handle_cast(:update, _state) do
    Logger.info("Updating Channels cache")
    # Fetch and cache
    :ok = cache_channels!()

    Process.sleep(@cache_update_interval)

    update()
    {:noreply, :ok}
  end

  # Client

  def update(pid \\ __MODULE__) do
    GenServer.cast(pid, :update)
  end

  @doc """
  Get a list of all channels.
  """
  @spec get_channels :: list(%Channel{})
  def get_channels() do
    Memento.transaction!(fn ->
      Memento.Query.all(Channel)
    end)
  end

  def get_channels_top_subs(limit \\ 10) do
    get_channels() |> Enum.sort_by(& &1.subscriber_count, :desc) |> Enum.take(limit)
  end

  def get_channels_top_views(limit \\ 10) do
    get_channels() |> Enum.sort_by(& &1.view_count, :desc) |> Enum.take(limit)
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
    Logger.info("Setting up Mnesia table.")
    Memento.Table.create!(Channel)
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
