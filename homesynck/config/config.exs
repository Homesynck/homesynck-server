# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :homesynck,
  ecto_repos: [Homesynck.Repo]

# Configures the endpoint
config :homesynck, HomesynckWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "4/C3AXYcHnXKHs1WJtPVBO1uq9tV32YG+PuRlNTdfUHVY6OQHI0Hpd2eJIqaI4/w",
  render_errors: [view: HomesynckWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Homesynck.PubSub,
  live_view: [signing_salt: "IiReN4Rz"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
import_config "homesynck.exs"
