defmodule ApiTasks.Repo do
  use Ecto.Repo,
    otp_app: :api_tasks,
    adapter: Ecto.Adapters.Postgres
end
