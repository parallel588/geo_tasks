defmodule ApiTasks.Tests.Helpers do
  @moduledoc """
  Helpers for use in tests.
  """

  defmacro __using__(_opts) do
    quote do
      # check 401 response when user not logged in
      #
      defmacro assert_unauthentication(conn, do: yield) do
        quote do
          conn =
            unquote(conn)
            |> unquote(yield)

          assert conn.state == :sent
          assert conn.status == 401
          assert conn.resp_body == "unauthorized"
        end
      end

      # check permissions for action
      defmacro assert_unauthorize(conn, do: yield) do
        quote do
          conn =
            unquote(conn)
            |> unquote(yield)

          assert conn.state == :sent
          assert conn.status == 403
          assert conn.resp_body == Jason.encode!(%{status: :unauthorized})
        end
      end
    end
  end
end
