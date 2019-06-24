# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# Print only warnings and errors during test
config :logger, level: :warn
config :api_tasks, :endpoint, port: 4002

if File.exists?("./config/test.secret.exs") do
  import_config "test.secret.exs"
end
