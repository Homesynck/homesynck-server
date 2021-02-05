defmodule Server.Protocol.TcpTls do
  require Logger
  @behaviour Server.Protocol

  @impl true
  def init(
        %{
          port: port,
          cert_path: cert_path
        } = _protocol_opts
      ) do
    :ssl.start()

    {:ok, accept_socket} =
      :ssl.listen(
        port,
        [
          {:certfile, Path.join(cert_path, ".crt")},
          {:keyfile, Path.join(cert_path, ".key")},
          {:active, false},
          {:reuseaddr, true}
        ]
      )

    accept_socket
  end

  @impl true
  def accept(accept_socket) do
    {:ok, tls_transport_socket} = :ssl.transport_accept(accept_socket)
    {:ok, peername} = :ssl.peername(tls_transport_socket)

    {:ok, client_socket} = :ssl.handshake(tls_transport_socket)

    Logger.info("[#{__MODULE__}] successfully handshaked with #{inspect(peername)}")

    client_socket
  end

  @impl true
  def receive_blocking(socket) do
    :ssl.recv(socket, 0)
  end

  @impl true
  def send(socket, data) do
    :ssl.send(socket, data)
  end
end
