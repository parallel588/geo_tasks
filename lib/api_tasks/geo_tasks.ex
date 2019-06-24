defmodule ApiTasks.GeoTasks do
  @moduledoc false

  alias __MODULE__.{Changeset, GeoTask, Query}
  alias ApiTasks.Repo

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
  def update_status(%GeoTask{} = task, status) do
    task
    |> Changeset.update_status(status)
    |> Repo.update()
  end
end
