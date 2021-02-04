defmodule Server.Acceptor do
  use Task, restart: :permanent
  require Logger

  def start_link({_, {protocol_module, protocol_opts}, _} = server_data) do
    accept_socket = protocol_module.init(protocol_opts)
    Task.start_link(__MODULE__, :run, [accept_socket, server_data])
  end

  def run(accept_socket, {_, {protocol_module, _}, _} = server_data) do
    client_socket = protocol_module.accept(accept_socket)
    on_connection(client_socket, server_data)

    run(accept_socket, server_data)
  end

  def on_connection(socket, {server, protocol, service} = server_data) do
    Server.on_connection(server, socket, protocol, service)
  end
end
