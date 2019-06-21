defmodule ApiTasks.GeoTasks do
  import Ecto.Changeset
  alias ApiTasks.Repo

  alias __MODULE__.GeoTask
  alias __MODULE__.Query

  @doc "Gets undone tasks"
  @spec list(map()) :: list(GeoTask.t())
  def list(coordinates \\ %{}) do
    Query.undone()
    |> Query.near_sphere(coordinates)
    |> Repo.all()
  end

  @doc """
  Creates task
  """
  @spec create(map()) :: {:ok, GeoTask.t()} | {:error, Ecto.Changeset.t()}
  def create(attrs \\ %{}) do
    %GeoTask{}
    |> cast_location(:dropoff_point, "dropoff_lat", "dropoff_long", attrs)
    |> cast_location(:pickup_point, "pickup_lat", "pickup_long", attrs)
    |> Repo.insert()
  end

  @doc "Deletes task"
  @spec delete(GeoTask.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def delete(task), do: Repo.delete(task)

  @doc "Assigns task to driver"
  @spec assign(GeoTask.t()) :: {:ok, GeoTask.t()} | {:error, Ecto.Changeset.t()}
  def assign(%GeoTask{} = task) do
    task
    |> change(status: GeoTask.statuses()[:assigned])
    |> Repo.update()
  end

  @doc "Complete task"
  @spec done(GeoTask.t()) :: {:ok, GeoTask.t()} | {:error, Ecto.Changeset.t()}
  def done(%GeoTask{} = task) do
    task
    |> change(status: GeoTask.statuses()[:done])
    |> Repo.update()
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
