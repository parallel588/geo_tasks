# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

if File.exists?("./config/dev.secret.exs") do
  import_config "dev.secret.exs"
end
