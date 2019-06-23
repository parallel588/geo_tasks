defmodule ApiTasks.GeoTasksTest do
  use ExUnit.Case
  use ApiTasks.DataCase

  import ApiTasks.Factory

  alias ApiTasks.GeoTasks
  alias ApiTasks.Repo

  test "creates task" do
    pickup = %{"lat" => "36.174968", "long" => "-115.137222"}

    dropoff = %{
      "lat" => "36.124642",
      "long" => "-115.171137"
    }

    {:ok, task} = GeoTasks.create(pickup, dropoff)
    assert task.status == GeoTasks.GeoTask.statuses()[:new]

    assert task.dropoff_point == %Geo.Point{
             coordinates: {-115.171137, 36.124642},
             properties: %{},
             srid: 4326
           }

    assert task.pickup_point == %Geo.Point{
             properties: %{},
             srid: 4326,
             coordinates: {-115.137222, 36.174968}
           }
  end

  test "deletes task" do
    task = insert(:task)
    assert {:ok, %GeoTasks.GeoTask{}} = GeoTasks.delete(task)
    assert length(Repo.all(GeoTasks.GeoTask)) == 0
  end

  test "updates status to assigned" do
    task = insert(:task)

    {:ok, %GeoTasks.GeoTask{} = updated_task} =
      GeoTasks.update_status(
        task,
        :assigned
      )

    assert updated_task.status == GeoTasks.GeoTask.statuses()[:assigned]
  end

  test "updates status to done" do
    task = insert(:task)

    {:ok, %GeoTasks.GeoTask{} = updated_task} =
      GeoTasks.update_status(
        task,
        :done
      )

    assert updated_task.status == GeoTasks.GeoTask.statuses()[:done]
  end

  test "get tasks" do
    task1 =
      insert(:task, pickup_point: %Geo.Point{coordinates: {36.128296, -115.186965}, srid: 4326})

    task2 =
      insert(:task, pickup_point: %Geo.Point{coordinates: {36.124493, -115.182392}, srid: 4326})

    task3 =
      insert(:task, pickup_point: %Geo.Point{coordinates: {36.135705, -115.224044}, srid: 4326})

    _done_task = insert(:task, status: GeoTasks.GeoTask.statuses()[:done])

    tasks = GeoTasks.list({36.124404, -115.172605})
    assert tasks == [task2, task1, task3]
  end
end
