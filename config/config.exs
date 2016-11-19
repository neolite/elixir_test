# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :api_test,
  ecto_repos: [ApiTest.Repo]

# Configures the endpoint
config :api_test, ApiTest.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "t4O86M4RUrcRIx4CiUNR8q2dcYBjjYxI1U66gewH+m1quwcl/vTjCG1JsiKUuVKZ",
  render_errors: [view: ApiTest.ErrorView, accepts: ~w(json)],
  pubsub: [name: ApiTest.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
