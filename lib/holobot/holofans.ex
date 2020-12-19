defmodule Holobot.Holofans do
  @moduledoc """

  The Holofans / Holotools API context.
  """

  def list_live_channels() do
    [
      %{channel_name: "watame"},
      %{channel_name: "sora"}
    ]
  end

end
