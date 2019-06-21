# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :api_tasks, ApiTasks.Repo,
  adapter: Ecto.Adapters.Postgres,
  types: ApiTasks.PostgresTypes,
  username: "postgres",
  password: "postgres",
  database: "geo_tasks_dev",
  hostname: "localhost",
  pool_size: 10

if File.exists?("./config/dev.secret.exs") do
  import_config "dev.secret.exs"
end
