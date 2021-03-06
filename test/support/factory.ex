defmodule ApiTasks.Factory do
  @moduledoc false

  use ExMachina.Ecto, repo: ApiTasks.Repo
  alias ApiTasks.GeoTasks.GeoTask

  def task_factory do
    %GeoTask{
      dropoff_point: %Geo.Point{
        coordinates: {36.124642, -115.171137},
        srid: 4326
      },
      pickup_point: %Geo.Point{
        coordinates: {36.174968, -115.137222},
        srid: 4326
      }
    }
  end

  def done_task_factory do
    struct!(
      task_factory(),
      %{
        status: GeoTask.statuses()[:done]
      }
    )
  end
end
