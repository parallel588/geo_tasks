# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn

config :api_tasks, ApiTasks.Repo,
  adapter: Ecto.Adapters.Postgres,
  types: ApiTasks.PostgresTypes,
  username: "postgres",
  password: "postgres",
  database: "geo_tasks_test",
  hostname: System.get_env("DB_HOST") || "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

if File.exists?("./config/test.secret.exs") do
  import_config "test.secret.exs"
end
