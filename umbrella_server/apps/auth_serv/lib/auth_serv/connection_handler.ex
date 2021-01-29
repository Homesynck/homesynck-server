defmodule AuthServ.ConnectionHandler do
  @moduledoc """
  Listens for connections and redirects to the appropriate service
  """

  require Logger # using Logger's macros
  use GenServer # building upon GenServer's behaviour

  defmodule State do
    defstruct port: nil,
              listen_socket: nil,
              service: nil
  end

  @doc """
  Mendatory GenServer callback
  """
  def start_link(%{port: port, service: service}) do
    GenServer.start_link(
      __MODULE__,
      %State{
        port: port,
        service: service
      },
      name: __MODULE__)
  end

  @doc """
  Mendatory GenServer callback that asynchronously triggers handle_continue
  """
  def init(state) do
    {:ok, state, {:continue, :start_accepting}}
  end

  def handle_continue(
    :start_accepting,
    %State{
      port: port, service: service
    } = state
  ) do
    {:ok, listen_socket} = start_listening_ssl(port)
    Logger.info("[#{__MODULE__}] started ssl server on port #{port} for service #{service}")

    Logger.info("[#{__MODULE__}] started accepting connections")

    accept_connection(listen_socket)

    Logger.info("[#{__MODULE__}] stopped accepting connections")

    {:noreply, state}
  end

  defp start_listening_ssl(port) do
    :ssl.start()
    :ssl.listen(
      port,
      [{:certfile, Path.join(:code.priv_dir(:auth_serv), "certificates/ssl.crt")},
      {:keyfile, Path.join(:code.priv_dir(:auth_serv), "certificates/ssl.key")}])
  end

  defp accept_connection(listen_socket) do
    {:ok, tls_transport_socket} = :ssl.transport_accept(listen_socket)
    {:ok, peername} = :ssl.peername(tls_transport_socket)

    Logger.info("[#{__MODULE__}] successfully accepted connection with #{inspect peername}")

    {:ok, socket} = :ssl.handshake(tls_transport_socket)

    Logger.info("[#{__MODULE__}] successfully handshaked with #{inspect peername}")
    #:ssl.send(socket, 'Mon super message\n')
    accept_connection(listen_socket)
  end
end
