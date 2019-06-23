defmodule ApiTasks.ApiController do
  @moduledoc """
  """

  alias ApiTasks.GeoTasks

  @doc """
  Gets list of unfulfilled  tasks. Sorted by distance from the  geo position.
  `position`:
  `lat`
  `long`
  """
  def list(conn, params) do
    tasks =
      params
      |> fetch_position
      |> GeoTasks.list()

    {conn, 200, Jason.encode!(%{status: :ok, tasks: tasks})}
  end

  @doc """
  Creates new tasks with pickup and dropoff position
  """
  def create(conn, %{"dropoff" => dropoff, "pickup" => pickup} = _params) do
    case GeoTasks.create(pickup, dropoff) do
      {:ok, _task} ->
        {conn, 200, Jason.encode!(%{status: :ok})}

      {:error, changeset} ->
        {
          conn,
          422,
          Jason.encode!(%{status: :error, messages: validate_errors(changeset)})
        }
    end
  end

  def create(conn, _params), do: bad_request(conn)

  @doc """
  Updates status of task
  """
  def update(conn, task_id, %{"status" => status} = _) when status in ["assigned", "done"] do
    with {:ok, task} <- GeoTasks.get(task_id),
         {:ok, task} <- GeoTasks.update_status(task, status) do
      {conn, 200, Jason.encode!(%{status: :ok, task: task})}
    else
      {:error, :not_found} -> not_found_request(conn)
      _ -> bad_request(conn)
    end
  end

  def update(conn, _task_id, _params), do: bad_request(conn)

  @doc """
  Deletes task
  """
  def delete(conn, task_id) do
    with {:ok, task} <- GeoTasks.get(task_id),
         {:ok, _} <- GeoTasks.delete(task) do
      {conn, 200, Jason.encode!(%{status: :ok})}
    else
      {:error, :not_found} -> not_found_request(conn)
      _ -> bad_request(conn)
    end
  end

  # fetch driver position from params
  #
  defp fetch_position(%{"position" => %{"lat" => lat, "long" => long}} = _) do
    {lat, long}
  end

  defp fetch_position(_), do: {}

  # formatting validate errors
  #
  defp validate_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {msg, opts} ->
      Enum.reduce(opts, msg, fn {key, value}, _acc ->
        String.replace(msg, "%{#{key}}", to_string(value))
      end)
    end)
  end

  defp bad_request(conn) do
    {conn, 400, Jason.encode!(%{status: :bad_request})}
  end

  defp not_found_request(conn) do
    {conn, 404, Jason.encode!(%{status: :not_found})}
  end
end