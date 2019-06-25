defmodule ApiTasks.GeoTasks.GeoTaskTest do
  use ExUnit.Case

  alias ApiTasks.GeoTasks.GeoTask

  describe "get_status" do
    test "it returns digital status" do
      assert GeoTask.get_status("new") == 0
      assert GeoTask.get_status(:assigned) == 1
      assert GeoTask.get_status(:done) == 2
    end
  end

  describe "get_status_name" do
    test "it returns status name" do
      assert GeoTask.get_status_name(0) == :new
      assert GeoTask.get_status_name(1) == :assigned
      assert GeoTask.get_status_name(2) == :done
      assert GeoTask.get_status_name(3) == nil
    end
  end
end
