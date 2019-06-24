defmodule ApiTasks.GeoTasks do
  @moduledoc false

  alias __MODULE__.{Changeset, GeoTask, Query}
  alias ApiTasks.Repo

  @doc "
  Gets unfulfilled tasks sorted by distance of current position.
  `coordinates` - the tuple contains geo data of current position
  example: {lat, long} - {12.3443, -115.648}
  "
  @spec list(tuple() | {}) :: list(GeoTask.t())
  def list(coordinates \\ {}) do
    Query.unfulfilled()
    |> Query.near_sphere(coordinates)
    |> Repo.all()
  end

  @doc "Gets task by id"
  @spec get(String.t()) :: {:ok, GeoTask.t()} | {:error, :not_found}
  def get(id) do
    case Repo.one(Query.by_id(id)) do
      %GeoTask{} = task -> {:ok, task}
      _ -> {:error, :not_found}
    end
  end

  @doc """
  Creates task.

  `pickup` - pickup point, %{"lat" => "36.174", "long" => "-115.137"}
  `dropoff` - drop off point, %{"lat" => "36.642", "long" => "-115.137"}
  """
  @spec create(map(), map()) ::
          {:ok, GeoTask.t()} | {:error, Ecto.Changeset.t()}
  def create(pickup, dropoff) do
    pickup
    |> Changeset.create(dropoff)
    |> Repo.insert()
  end

  @doc "Deletes task"
  @spec delete(GeoTask.t()) :: {:ok, GeoTask.t()} | {:error, Ecto.Changeset.t()}
  def delete(task), do: Repo.delete(task)

  @doc "Updates status task"
  @spec update_status(GeoTask.t(), String.t()) ::
          {:ok, GeoTask.t()} | {:error, Ecto.Changeset.t()}
  def update_status(%GeoTask{} = task, status) do
    task
    |> Changeset.update_status(status)
    |> Repo.update()
  end
end
