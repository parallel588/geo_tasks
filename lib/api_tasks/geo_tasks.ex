defmodule ApiTasks.GeoTasks do
  import Ecto.Changeset
  alias ApiTasks.Repo

  alias __MODULE__.GeoTask
  alias __MODULE__.Query

  @doc "Gets undone tasks"
  @spec list(map()) :: list(GeoTask.t())
  def list(coordinates \\ {}) do
    Query.undone()
    |> Query.near_sphere(coordinates)
    |> Repo.all()
  end

  @doc "Gets task"
  @spec get(String.t()) :: {:ok, GeoTask.t()} | {:error, :not_found}
  def get(id) do
    case Repo.one(Query.by_id(id)) do
      %GeoTask{} = task -> {:ok, task}
      _ -> {:error, :not_found}
    end
  end

  @doc """
  Creates task
  """
  @spec create(map(), map()) :: {:ok, GeoTask.t()} | {:error, Ecto.Changeset.t()}
  def create(pickup, dropoff) do
    %GeoTask{}
    |> cast_location(:dropoff_point, "lat", "long", dropoff)
    |> cast_location(:pickup_point, "lat", "long", pickup)
    |> validate_required([:pickup_point, :dropoff_point])
    |> Repo.insert()
  end

  @doc "Deletes task"
  @spec delete(GeoTask.t()) :: {:ok, Ecto.Schema.t()} | {:error, Ecto.Changeset.t()}
  def delete(task), do: Repo.delete(task)

  @doc "Updates status task"
  def update_status(%GeoTask{} = task, status) do
    task
    |> change(status: GeoTask.get_status(status))
    |> validate_required([:status])
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
