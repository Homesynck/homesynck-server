defmodule Server do
  @moduledoc """
  A module that implements a networking service/server behaviour.
  """
  use Supervisor

  @services_sup ServicesSupervisor

  def on_connection(server, socket, protocol, service) do
    {:ok, pid} =
      DynamicSupervisor.start_child(
        services_sup_name(server),
        {Server.Service, :start_link, [{socket, protocol, service}]}
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
      {@services_sup, name: services_sup_name(name)},
      {Server.Acceptor, :start_link, [{name, protocol, service}], name: :"#{name}.Acceptor"}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp services_sup_name(server) do
    :"#{server}.#{@services_sup}"
  end
end
