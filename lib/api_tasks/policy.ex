defmodule ApiTasks.Policy do
  @moduledoc """
  The module checks permissions to perform actions.
  """

  import ApiTasks.Tokens, only: [is_driver: 1, is_manager: 1]

  @spec authorize(Plug.Conn.t(), atom(), any) :: :ok | {:error, :unauthorized}
  def authorize(_conn, _action, _object \\ nil)

  def authorize(%Plug.Conn{assigns: %{user_role: role}} = _, action, _)
      when action == :get_tasks and is_driver(role),
      do: :ok

  def authorize(%Plug.Conn{assigns: %{user_role: role}} = _, action, _)
      when action == :create_task and is_manager(role),
      do: :ok

  def authorize(%Plug.Conn{assigns: %{user_role: role}} = _, action, _)
      when action == :update_status and is_driver(role),
      do: :ok

  def authorize(%Plug.Conn{assigns: %{user_role: role}} = _, action, _)
      when action == :delete_task and is_manager(role),
      do: :ok

  def authorize(%Plug.Conn{} = _conn, _action, _object) do
    {:error, :unauthorized}
  end
end
