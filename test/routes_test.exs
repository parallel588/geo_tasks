defmodule ApiTasks.RoutesTest do
  use ExUnit.Case, async: true
  use ApiTasks.DataCase
  use Plug.Test

  use ApiTasks.Tests.Helpers
  import ApiTasks.Factory

  alias ApiTasks.GeoTasks
  alias ApiTasks.GeoTasks.GeoTask
  @manager_token "npFjLbDy_3-njP4KLWTd5K64XqorAiwcMcfdKE1qgBecyeFZdT"
  @driver_token "r9AlnQyHM9D34iv-lvGPYa41InCvxMoGpYfBOwHvblc7uHz8Ez"

  @opts ApiTasks.Routes.init([])

  @driver_position %{lat: 36.124404, long: -115.172605}

  describe "GET /tasks" do
    test "its returns 401 if auth token is missing" do
      assert_unauthentication(conn(:get, "/tasks", %{position: @driver_position})) do
        ApiTasks.Routes.call(@opts)
      end
    end

    test "its returns 401 if auth token is invalid" do
      assert_unauthentication(conn(:get, "/tasks", %{position: @driver_position})) do
        put_req_header("authorization", "token")
        |> ApiTasks.Routes.call(@opts)
      end
    end

    test "its returns 403 if user role isn't driver" do
      assert_unauthorize(conn(:get, "/tasks", %{position: @driver_position})) do
        put_req_header("authorization", @manager_token)
        |> ApiTasks.Routes.call(@opts)
      end
    end

    test "it returns unfulfilled tasks" do
      _task1 =
        insert(:task,
          pickup_point: %Geo.Point{
            coordinates: {36.128296, -115.186965},
            srid: 4326
          },
          status: GeoTasks.GeoTask.statuses()[:done]
        )

      task2 =
        insert(:task, pickup_point: %Geo.Point{coordinates: {36.124493, -115.182392}, srid: 4326})

      task3 =
        insert(:task, pickup_point: %Geo.Point{coordinates: {36.135705, -115.224044}, srid: 4326})

      _done_task = insert(:done_task)

      conn =
        conn(:get, "/tasks", %{position: %{lat: 36.124404, long: -115.172605}})
        |> put_req_header("authorization", @driver_token)
        |> ApiTasks.Routes.call(@opts)

      assert conn.state == :sent
      assert conn.status == 200
      assert conn.resp_body == Jason.encode!(%{status: :ok, tasks: [task2, task3]})
    end
  end

  describe "DELETE /task/:id - deletes task" do
    test "its returns 401 if auth token is missing" do
      assert_unauthentication(conn(:delete, "/task/1")) do
        ApiTasks.Routes.call(@opts)
      end
    end

    test "its returns 401 if auth token is invalid" do
      assert_unauthentication(conn(:delete, "/task/1")) do
        put_req_header("authorization", "token")
        |> ApiTasks.Routes.call(@opts)
      end
    end

    test "its returns 403 if user role is driver" do
      task = insert(:task)

      assert_unauthorize(conn(:delete, "/task/#{task.id}")) do
        put_req_header("authorization", @driver_token)
        |> ApiTasks.Routes.call(@opts)
      end
    end

    test "it returns ok" do
      task = insert(:task)

      conn =
        conn(:delete, "/task/#{task.id}")
        |> put_req_header("authorization", @manager_token)
        |> ApiTasks.Routes.call(@opts)

      refute Repo.get(GeoTask, task.id)
      assert conn.state == :sent
      assert conn.status == 200
      assert conn.resp_body == Jason.encode!(%{status: :ok})
    end
  end

  describe "PUT /task/:id - updates task" do
    test "its returns 401 if auth token is missing" do
      assert_unauthentication(conn(:put, "/task/1", %{status: "assigned"})) do
        ApiTasks.Routes.call(@opts)
      end
    end

    test "its returns 401 if auth token is invalid" do
      assert_unauthentication(conn(:put, "/task/1", %{status: "assigned"})) do
        put_req_header("authorization", "token")
        |> ApiTasks.Routes.call(@opts)
      end
    end

    test "its returns 403 if user role is manager" do
      task = insert(:task)

      assert_unauthorize(conn(:put, "/task/#{task.id}", %{status: "assigned"})) do
        put_req_header("authorization", @manager_token)
        |> ApiTasks.Routes.call(@opts)
      end
    end

    test "it returns assigned task" do
      task = insert(:task)

      conn =
        conn(:put, "/task/#{task.id}", %{status: "assigned"})
        |> put_req_header("authorization", @driver_token)
        |> ApiTasks.Routes.call(@opts)

      updated_task = Repo.get(GeoTask, task.id)
      assert updated_task.status == GeoTask.statuses()[:assigned]
      assert conn.state == :sent
      assert conn.status == 200
      assert conn.resp_body == Jason.encode!(%{status: :ok, task: updated_task})
    end

    test "it returns done task" do
      task = insert(:task)

      conn =
        conn(:put, "/task/#{task.id}", %{status: "done"})
        |> put_req_header("authorization", @driver_token)
        |> ApiTasks.Routes.call(@opts)

      updated_task = Repo.get(GeoTask, task.id)
      assert updated_task.status == GeoTask.statuses()[:done]
      assert conn.state == :sent
      assert conn.status == 200
      assert conn.resp_body == Jason.encode!(%{status: :ok, task: updated_task})
    end

    test "it doesn't must update status when status is ivalid" do
      task = insert(:task)

      conn =
        conn(:put, "/task/#{task.id}", %{status: "pick"})
        |> put_req_header("authorization", @manager_token)
        |> ApiTasks.Routes.call(@opts)

      updated_task = Repo.get(GeoTask, task.id)
      assert updated_task.status == GeoTask.statuses()[:new]
      assert conn.state == :sent
      assert conn.status == 400
      assert conn.resp_body == Jason.encode!(%{status: "bad_request"})
    end
  end

  describe "POST /tasks - create task" do
    test "its returns 401 if auth token is missing" do
      assert_unauthentication(conn(:post, "/tasks", %{dropoff: %{}, pickup: %{}})) do
        ApiTasks.Routes.call(@opts)
      end
    end

    test "its returns 401 if auth token is invalid" do
      assert_unauthentication(conn(:post, "/tasks", %{dropoff: %{}, pickup: %{}})) do
        put_req_header("authorization", "token")
        |> ApiTasks.Routes.call(@opts)
      end
    end

    test "its returns 403 if user role is driver" do
      assert_unauthorize(conn(:post, "/tasks", %{dropoff: %{}, pickup: %{}})) do
        put_req_header("authorization", @driver_token)
        |> ApiTasks.Routes.call(@opts)
      end
    end

    test "it creates new task" do
      params = %{
        dropoff: %{lat: 36.124642, long: -115.171137},
        pickup: %{lat: 36.174968, long: -115.137222}
      }

      conn =
        conn(:post, "/tasks", params)
        |> put_req_header("authorization", @manager_token)
        |> ApiTasks.Routes.call(@opts)

      [task] = Repo.all(GeoTask)
      assert conn.state == :sent
      assert conn.status == 200
      assert conn.resp_body == Jason.encode!(%{status: :ok, task: task})
    end

    test "it returns bad_request if locations if empty" do
      params = %{
        dropoff: %{lat: 36.124642, long: -115.171137}
      }

      conn =
        conn(:post, "/tasks", params)
        |> put_req_header("authorization", @manager_token)
        |> ApiTasks.Routes.call(@opts)

      assert conn.state == :sent
      assert conn.status == 400
      assert conn.resp_body == Jason.encode!(%{status: "bad_request"})
    end

    test "it returns error if pickup point is empty" do
      params = %{
        dropoff: %{lat: 36.124642, long: -115.171137},
        pickup: %{}
      }

      conn =
        conn(:post, "/tasks", params)
        |> put_req_header("authorization", @manager_token)
        |> ApiTasks.Routes.call(@opts)

      assert conn.state == :sent
      assert conn.status == 422

      assert conn.resp_body ==
               Jason.encode!(%{messages: %{pickup_point: ["can't be blank"]}, status: "error"})
    end
  end
end
