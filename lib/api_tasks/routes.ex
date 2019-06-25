defmodule ApiTasks.Routes do
  @moduledoc "Api Routers"

  use Plug.Router
  alias ApiTasks.ApiController
  alias ApiTasks.AuthenticationPlug

  plug(Plug.Logger)
  plug(AuthenticationPlug)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  get "/tasks" do
    conn
    |> ApiController.list(conn.query_params)
    |> build_response
  end

  post "/tasks" do
    conn
    |> ApiController.create(conn.body_params)
    |> build_response
  end

  match "/task/:task_id", via: :put do
    conn
    |> ApiController.update(task_id, conn.body_params)
    |> build_response
  end

  match "/task/:task_id", via: :delete do
    conn
    |> ApiController.delete(task_id)
    |> build_response
  end

  match _ do
    build_response({conn, 404, "not found resources"})
  end

  # build json response
  #
  defp build_response({conn, status, response}) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, response)
  end
end
