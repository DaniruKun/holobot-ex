defmodule Holobot.Holofans.Channels do
  @moduledoc """
  Holofans API channels context.
  """

  @holofans_api "https://api.holotools.app/v1"

  alias Holobot.Holofans.Channel
  import Finch

  def get_channels() do
    encoded_query = URI.encode_query(%{"sort" => "name"})
    req = build(:get, @holofans_api <> "/channels?" <> encoded_query)
    {:ok, resp} = request(req, HolofansAPIClient)
    {:ok, decoded_body} = resp.body |> Jason.decode()
    decoded_body |> Map.get("channels")
  end
end
