defmodule ApiTasks.Policy do
  @moduledoc false

  import ApiTasks.Tokens, only: [is_driver: 1, is_manager: 1]

  def authorize(_conn, _action, _object \\ nil)

  def authorize(%Plug.Conn{assigns: %{user_role: role}} = _, action, _)
      when action == :get_tasks and is_driver(role) do
    :ok
  end

  def authorize(%Plug.Conn{assigns: %{user_role: role}} = _, action, _)
      when action == :create_task and is_manager(role) do
    :ok
  end

  def authorize(%Plug.Conn{assigns: %{user_role: role}} = _, action, _)
      when action == :update_status and is_driver(role) do
    :ok
  end

  def authorize(%Plug.Conn{assigns: %{user_role: role}} = _, action, _)
      when action == :delete_task and is_manager(role) do
    :ok
  end

  def authorize(%Plug.Conn{} = _conn, _action, _object) do
    {:error, :unauthorized}
  end
end
