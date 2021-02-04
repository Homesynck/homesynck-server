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
      :ssl.accept(
        port,
        [{:certfile, Path.join(cert_path, ".crt")}, {:keyfile, Path.join(cert_path, ".key")}]
      )

    accept_socket
  end

  @impl true
  def accept(accept_socket) do
    {:ok, tls_transport_socket} = :ssl.transport_accept(accept_socket)
    {:ok, peername} = :ssl.peername(tls_transport_socket)

    Logger.info("[#{__MODULE__}] successfully accepted connection with #{inspect(peername)}")

    {:ok, client_socket} = :ssl.handshake(tls_transport_socket)

    Logger.info("[#{__MODULE__}] successfully handshaked with #{inspect(peername)}")

    client_socket
  end

  @impl true
  def receive_blocking(socket) do
    :ssl.recv(socket)
  end

  @impl true
  def send(socket, data) do
    :ssl.send(socket, data)
  end
end