# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :discuss,
  ecto_repos: [DiscussWeb.Repo]

# Configures the endpoint
config :discuss, DiscussWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "F6K6enpqa4YSsXBg1G1UJzT8nKMNGi5ovkZhw9Vczb0lu2gPZkxM9AHjGNdirVHh",
  render_errors: [view: DiscussWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: DiscussWeb.PubSub,
  live_view: [signing_salt: "g4pbUI6K"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]
# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, []}
  ]
config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "f515c54d6d8b2001e076",
  client_secret: "2ff264da25afb8ef1aa8a2d86781df897de59df2"
# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
