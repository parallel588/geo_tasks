defmodule ApiTasks.AuthenticationPlugTest do
  use ExUnit.Case
  use Plug.Test
  @driver_token "r9AlnQyHM9D34iv-lvGPYa41InCvxMoGpYfBOwHvblc7uHz8Ez"

  test "it throws a 401 if token is not present" do
    conn = ApiTasks.AuthenticationPlug.call(conn(:get, "/"), %{})

    assert conn.status == 401
    assert conn.resp_body == "unauthorized"
  end

  test "it throws a 401 if token is invalid" do
    conn =
      conn(:get, "/")
      |> put_req_header("authorization", "token")
      |> ApiTasks.AuthenticationPlug.call(%{})

    assert conn.status == 401
    assert conn.resp_body == "unauthorized"
  end

  test "it assign role and token if token is valid" do
    conn =
      conn(:get, "/tasks")
      |> put_req_header("authorization", @driver_token)
      |> ApiTasks.AuthenticationPlug.call(%{})

    assert conn.assigns == %{
             user_role: "driver",
             user_token: @driver_token
           }
  end
end
