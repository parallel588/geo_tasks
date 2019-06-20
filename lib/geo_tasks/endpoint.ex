defmodule GeoTasks.Endpoint do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Jason)
  plug(:dispatch)

  # Test
  get "/test" do
    send_resp(conn, 200, "test")
  end

  match _ do
    send_resp(conn, 404, "not found resources")
  end
end
