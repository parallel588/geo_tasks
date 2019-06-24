defmodule ApiTasks.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  import Supervisor.Spec, warn: false

  def start(_type, _args) do
    # List all child processes to be supervised
    endpoint_config = Application.get_env(:api_tasks, :endpoint)

    children = [
      supervisor(ApiTasks.Repo, []),
      Plug.Cowboy.child_spec(
        scheme: :http,
        plug: ApiTasks.Endpoint,
        options: [port: Keyword.get(endpoint_config, :port, 4001)]
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ApiTasks.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
