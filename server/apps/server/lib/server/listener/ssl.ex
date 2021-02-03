defmodule Server.Listener.SSL do
  require Logger
  use Server.Listener

  @impl true
  def init_listen_socket(
        %{
          port: port,
          cert_path: cert_path
        } = _listener_arg
      ) do
    :ssl.start()

    {:ok, listen_socket} =
      :ssl.listen(
        port,
        [{:certfile, Path.join(cert_path, ".crt")}, {:keyfile, Path.join(cert_path, ".key")}]
      )

    listen_socket
  end

  @impl true
  def listen(listen_socket) do
    {:ok, tls_transport_socket} = :ssl.transport_accept(listen_socket)
    {:ok, peername} = :ssl.peername(tls_transport_socket)

    Logger.info("[#{__MODULE__}] successfully accepted connection with #{inspect(peername)}")

    {:ok, client_socket} = :ssl.handshake(tls_transport_socket)

    Logger.info("[#{__MODULE__}] successfully handshaked with #{inspect(peername)}")

    client_socket
  end
end
