defmodule ApiTasks.Policy do

  def authorize(_conn, _action, _object \\ nil)

  def authorize(%Plug.Conn{assigns: %{user_role: role}} = _, action, _)
  when action == :get_tasks and role == "driver" do
    :ok
  end


  def authorize(%Plug.Conn{assigns: %{user_role: role}} = _, action, _)
  when action == :create_task and role == "manager" do
    :ok
  end

  def authorize(%Plug.Conn{assigns: %{user_role: role}} = _, action, _)
  when action == :update_status and  role == "driver" do
    :ok
  end

  def authorize(%Plug.Conn{assigns: %{user_role: role}} = _, action, _)
  when action == :delete_task and  role == "manager" do
    :ok
  end

  def authorize(%Plug.Conn{} = _conn, _action, _object) do
    {:error, :unauthorized}
  end
end
