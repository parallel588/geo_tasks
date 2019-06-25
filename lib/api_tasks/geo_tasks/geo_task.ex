defmodule ApiTasks.GeoTasks.GeoTask do
  @moduledoc false
  use Ecto.Schema
  @type t :: %__MODULE__{}

  @statuses %{
    new: 0,
    assigned: 1,
    done: 2
  }
  schema "geo_tasks" do
    field(:dropoff_point, Geo.PostGIS.Geometry)
    field(:pickup_point, Geo.PostGIS.Geometry)
    field(:status, :integer, default: @statuses[:new])
  end

  def statuses, do: @statuses

  @doc "Gets digital status by status name"
  @spec get_status(any()) :: integer() | nil
  def get_status(status) when is_binary(status),
    do: get_status(String.to_atom(status))

  def get_status(status) when is_atom(status), do: @statuses[status]
  def get_status(_status), do: nil

  @doc "Gets status name by digital status"
  @spec get_status_name(any()) :: atom() | nil
  def get_status_name(%__MODULE__{status: status} = _),
    do: get_status_name(status)

  def get_status_name(status) when is_integer(status) do
    with {value, _} <- Enum.find(@statuses, fn {_k, v} -> v == status end) do
      value
    end
  end

  def get_status_name(_), do: nil
end

defimpl Jason.Encoder, for: Geo.Point do
  def encode(%Geo.Point{coordinates: {lat, long}} = _value, opts) do
    Jason.Encode.map(%{lat: lat, long: long}, opts)
  end
end

defimpl Jason.Encoder, for: ApiTasks.GeoTasks.GeoTask do
  def encode(task, opts) do
    task
    |> Map.take([:id, :dropoff_point, :pickup_point])
    |> Map.put(:status, ApiTasks.GeoTasks.GeoTask.get_status_name(task))
    |> Jason.Encode.map(opts)
  end
end
