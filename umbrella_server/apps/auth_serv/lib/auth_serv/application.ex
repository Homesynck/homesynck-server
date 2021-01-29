defmodule AuthServ.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    ch_state = %{:port => 3000, :service => nil}

    children = [
      # Starts a worker by calling: AuthServ.Worker.start_link(arg)
      # {AuthServ.Worker, arg}
      {AuthServ.ConnectionHandler, ch_state}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: AuthServ.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
