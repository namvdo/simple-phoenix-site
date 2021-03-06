defmodule Discuss.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      DiscussWeb.Repo,
      # Start the Telemetry supervisor
      DiscussWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: DiscussWeb.PubSub},
      # Start the Endpoint (http/https)
      DiscussWeb.Endpoint,
      # Start a worker by calling: Discuss.Worker.start_link(arg)
      # {Discuss.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: DiscussWeb.Supervisor]
    Supervisor.start_link(children, opts)
    Registry.start_link(keys: :unique, name: Rover.Registry)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    DiscussWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
