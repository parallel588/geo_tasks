defmodule ApiTasks.PolicyTest do
  use ExUnit.Case
  alias Plug.Conn
  alias ApiTasks.Policy

  @driver_conn %Conn{assigns: %{user_role: "driver"}}
  @manager_conn %Conn{assigns: %{user_role: "manager"}}

  describe "manager" do
    test "not permitted get tasks" do
      assert Policy.authorize(
               @manager_conn,
               :get_tasks
             ) == {:error, :unauthorized}
    end

    test "not permitted update status" do
      assert Policy.authorize(
               @manager_conn,
               :update_status
             ) == {:error, :unauthorized}
    end

    test "permitted create task" do
      assert Policy.authorize(@manager_conn, :create_task) == :ok
    end

    test "permitted delete task" do
      assert Policy.authorize(@manager_conn, :delete_task) == :ok
    end

    test "not permitted undefined action" do
      assert Policy.authorize(
               @manager_conn,
               :build_task
             ) == {:error, :unauthorized}
    end
  end

  describe "driver" do
    test "permitted get tasks" do
      assert Policy.authorize(@driver_conn, :get_tasks) == :ok
    end

    test "permitted update status" do
      assert Policy.authorize(@driver_conn, :update_status) == :ok
    end

    test "not permitted create new task" do
      assert Policy.authorize(
               @driver_conn,
               :create_task
             ) == {:error, :unauthorized}
    end

    test "not permitted delete task" do
      assert Policy.authorize(
               @driver_conn,
               :delete_task
             ) == {:error, :unauthorized}
    end

    test "not permitted undefined action" do
      assert Policy.authorize(
               @driver_conn,
               :build_task
             ) == {:error, :unauthorized}
    end
  end
end
