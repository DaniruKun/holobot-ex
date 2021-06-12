defmodule Holobot.Holofans.Client do
  @moduledoc """
  Holofans API HTTP client implementation, based on HTTPoison.
  """
  use HTTPoison.Base

  @expected_fields ~w(count total channels videos query comments)
  @api_version "v1"

  @impl true
  def process_request_url(url) do
    Application.fetch_env!(:holobot, :holofans_api) <> "#{@api_version}" <> url
  end

  @impl true
  def process_response_body(body) do
    body
    |> Poison.decode!()
    |> Map.take(@expected_fields)
    |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
  end
end
