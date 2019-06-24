defmodule ApiTasks.ApiController do
  @moduledoc false

  alias ApiTasks.GeoTasks
  import ApiTasks.Policy, only: [authorize: 3, authorize: 2]

  @doc """
  Gets list of unfulfilled  tasks. Sorted by distance from the  geo position.

  ## Endpoint
  GET /tasks

  ### Optional params
  - `position`:
      - `lat`
      - `long`

  ### Response
    `200` - Ok.
    `"status: ok, tasks: [....]"`
  """
  def list(conn, params) do
    with :ok <- authorize(conn, :get_tasks) do
      tasks =
        params
        |> fetch_position
        |> GeoTasks.list()

      {conn, 200, Jason.encode!(%{status: :ok, tasks: tasks})}
    else
      _ -> unauthorized_request(conn)
    end
  end

  @doc """
  Creates new tasks with pickup and dropoff position

  ## Endpoint
  POST /tasks

  ### Required params
  - `pickup`:
    - `lat`
    - `long`
  - `dropoff`:
    - `lat`
    - `long`

  ### Response
    #### Success
    `200` - Ok.

    #### Error
    `422`- invalid data
    `400` - bad request
    `403` - unauthorized
  """
  def create(conn, %{"dropoff" => dropoff, "pickup" => pickup} = _params) do
    with :ok <- authorize(conn, :create_task),
         {:ok, task} <- GeoTasks.create(pickup, dropoff) do
      {conn, 200, Jason.encode!(%{status: :ok, task: task})}
    else
      {:error, :unauthorized} ->
        unauthorized_request(conn)

      {:error, %Ecto.Changeset{} = changeset} ->
        {
          conn,
          422,
          Jason.encode!(%{status: :error, messages: validate_errors(changeset)})
        }

      _ ->
        bad_request(conn)
    end
  end

  def create(conn, _params), do: bad_request(conn)

  @doc """
  Updates status of task

  ## Endpoint
  PUT /tasks/:task_id

  ### Required params
  - `task_id`
  - `status` - must be "assigned" or "done"

  ### Response
  #### Success
  `200` - Ok.

  #### Error
  `404`- not found task
  `400` - bad request
  `403` - unauthorized
  """
  def update(conn, task_id, %{"status" => status} = _) when status in ["assigned", "done"] do
    with {:ok, task} <- GeoTasks.get(task_id),
         :ok <- authorize(conn, :update_status, task),
         {:ok, task} <- GeoTasks.update_status(task, status) do
      {conn, 200, Jason.encode!(%{status: :ok, task: task})}
    else
      {:error, :not_found} -> not_found_request(conn)
      {:error, :unauthorized} -> unauthorized_request(conn)
      _ -> bad_request(conn)
    end
  end

  def update(conn, _task_id, _params), do: bad_request(conn)

  @doc """
  Delete task

  ## Endpoint
  DELETE /tasks/:task_id

  ### Required params
  - `task_id`
  ### Response
  #### Success
  `200` - Ok.

  #### Error
  `404`- not found task
  `400` - bad request
  `403` - unauthorized
  """
  def delete(conn, task_id) do
    with {:ok, task} <- GeoTasks.get(task_id),
         :ok <- authorize(conn, :delete_task, task),
         {:ok, _} <- GeoTasks.delete(task) do
      {conn, 200, Jason.encode!(%{status: :ok})}
    else
      {:error, :not_found} -> not_found_request(conn)
      {:error, :unauthorized} -> unauthorized_request(conn)
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

  defp unauthorized_request(conn) do
    {conn, 403, Jason.encode!(%{status: :unauthorized})}
  end
end
