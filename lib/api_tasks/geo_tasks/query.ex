defmodule ApiTasks.GeoTasks.Query do
  @moduledoc false

  alias ApiTasks.GeoTasks.GeoTask
  import Ecto.Query, warn: false
  import Geo.PostGIS

  @doc "query by task id"
  def by_id(query \\ GeoTask, id) do
    from(q in query, where: q.id == ^id)
  end

  @doc "query for unfulfilled tasks"
  def unfulfilled(query \\ GeoTask) do
    done_status = GeoTask.statuses()[:done]
    from(q in query, where: q.status != ^done_status)
  end

  @doc "query to sort tasks by distance of location"
  def near_sphere(query \\ GeoTask, _location)

  def near_sphere(query, %Geo.Point{} = location) do
    from(q in query,
      order_by: [asc: st_distancesphere(q.pickup_point, ^location)]
    )
  end

  def near_sphere(query, {_lat, _long} = coordinates) do
    near_sphere(query, %Geo.Point{coordinates: coordinates, srid: 4326})
  end

  def near_sphere(query, _), do: query
end
