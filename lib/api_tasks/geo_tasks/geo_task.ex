defmodule ApiTasks.GeoTasks.GeoTask do
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
end
