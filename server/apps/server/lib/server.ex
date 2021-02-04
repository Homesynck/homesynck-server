defmodule Server do
  @moduledoc """
  A module that implements a networking service/server behaviour.
  """
  require Logger
  use Supervisor

  @services_sup Server.ServicesSupervisor

  def on_connection(server, socket, protocol, service) do
    {:ok, pid} =
      DynamicSupervisor.start_child(
        services_sup_name(server),
        {Server.Service, {socket, protocol, service}}
      )
  end

  def start_link(%{name: name} = init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: name)
  end

  @impl true
  def init(
        %{
          name: name,
          protocol: {_protocol_module, _protocol_opts} = protocol,
          service: {_service_module, _service_opts} = service
        } = _init_arg
      ) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: services_sup_name(name)},
      {Server.Acceptor, {name, protocol, service}}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp services_sup_name(server) do
    :"#{server}.ServicesSupervisor"
  end
end
