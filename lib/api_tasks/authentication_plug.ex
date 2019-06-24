defmodule ApiTasks.AuthenticationPlug do
  @moduledoc """
  """

  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    with token <- List.first(get_req_header(conn, "authorization")),
         {:ok, {token, role}} <- verify_token(token) do
      assigns_user(conn, {token, role})
    else
      _ -> unauthorized(conn)
    end
  end

  defp verify_token(token) when is_binary(token) do
    case ApiTasks.Tokens.fetch_role(token) do
      nil -> {:error, :not_found}
      role -> {:ok, {token, role}}
    end
  end
  defp verify_token(_), do: {:error, :invalid}

  defp assigns_user(conn, {token, role}) do
    conn
    |> assign(:user_role, role)
    |> assign(:user_token, token)
  end

  defp unauthorized(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(401, "unauthorized")
    |> halt
  end

end
