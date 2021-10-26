defmodule Holobot.Holofans.Channel do
  @moduledoc """
  Channel record schema and helper functions.
  """

  @primary_key :id
  @attrs Holodex.Model.Channel.__struct__()
         |> Map.from_struct()
         |> Map.keys()
         |> Enum.sort(fn a, _b -> a == @primary_key end)

  use ExConstructor

  use Memento.Table,
    attributes: @attrs,
    index: [:id, :name],
    type: :set
end
