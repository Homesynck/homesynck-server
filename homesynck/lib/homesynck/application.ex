defmodule Homesynck.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Homesynck.Repo,
      # Start the Telemetry supervisor
      HomesynckWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Homesynck.PubSub},
      # Start the Endpoint (http/https)
      HomesynckWeb.Endpoint,
      # Start a worker by calling: Homesynck.Worker.start_link(arg)
      # {Homesynck.Worker, arg}
      {Homesynck.Auth.AdminRegistrator, []}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Homesynck.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    HomesynckWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
