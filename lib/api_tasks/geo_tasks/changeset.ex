defmodule ApiTasks.GeoTasks.Changeset do
  @moduledoc false

  import Ecto.Changeset
  alias ApiTasks.GeoTasks.GeoTask

  def update_status(%GeoTask{} = task, status) do
    task
    |> change(status: GeoTask.get_status(status))
    |> validate_required([:status])
  end

  def create(pickup, dropoff) do
    %GeoTask{}
    |> cast_location(:dropoff_point, "lat", "long", dropoff)
    |> cast_location(:pickup_point, "lat", "long", pickup)
    |> validate_required([:pickup_point, :dropoff_point])
  end

  defp cast_location(changeset, set_attr, lat_attr, lng_attr, values) do
    lat = Map.get(values, lat_attr)
    lng = Map.get(values, lng_attr)
    do_cast_location(changeset, set_attr, lat, lng)
  end

  defp do_cast_location(changeset, set_attr, lat, lng)
       when is_binary(lat) and is_binary(lng) do
    case {Float.parse(lat), Float.parse(lng)} do
      {{:error}, _} ->
        changeset

      {{_}, :error} ->
        changeset

      {{latitude, _}, {longitude, _}} ->
        do_cast_location(changeset, set_attr, latitude, longitude)

      _ ->
        changeset
    end
  end

  defp do_cast_location(changeset, set_attr, lat, lng)
       when is_number(lat) and is_number(lng) do
    changeset
    |> change(%{set_attr => make_point({lat, lng})})
  end

  defp do_cast_location(changeset, _set_attr, _, _), do: changeset

  def make_point(coords \\ [])

  def make_point({lat, lng}) do
    %Geo.Point{coordinates: {lng, lat}, srid: 4326}
  end

  def make_point(coords) do
    make_point({coords[:lat], coords[:lng]})
  end
end
