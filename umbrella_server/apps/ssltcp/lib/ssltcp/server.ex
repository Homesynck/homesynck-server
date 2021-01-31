defmodule SSLTCP.Server do
  @moduledoc """
  Listens for connections and redirects to the appropriate service
  """

  # using Logger's macros
  require Logger
  # building upon GenServer's behaviour
  use GenServer

  defmodule State do
    defstruct port: nil,
              listen_socket: nil,
              service_type: nil,
              cert_path: nil,
              acceptor: nil
  end

  def start(pid) do
    listen_socket = GenServer.call(pid, :listen)
    GenServer.cast(pid, {:start, listen_socket})
  end

  def stop(pid) do
    GenServer.cast(pid, :stop)
  end

  @doc """
  Mendatory GenServer callback
  """
  def start_link(%{
        port: port,
        cert_path: cert_path,
        service_type: %{service: service, state_initiator: si}
      }) do
    {:ok, pid} =
      GenServer.start_link(
        __MODULE__,
        %State{
          port: port,
          cert_path: cert_path,
          service_type: %SSLTCP.ServiceType{
            service: service,
            state_initiator: si
          }
        },
        name: __MODULE__
      )

    start(pid)
    {:ok, pid}
  end

  @doc """
  Mendatory GenServer callback that asynchronously triggers handle_continue
  """
  def init(state) do
    {:ok, state}
  end

  def handle_call(
        :listen,
        _from,
        %State{
          port: port,
          cert_path: cert_path
        } = state
      ) do
    listen_socket = init_ssl(port, cert_path)
    {:reply, listen_socket, state}
  end

  def handle_cast(
        {:start, listen_socket},
        %State{
          service_type: service_type
        } = state
      ) do
    Logger.info("[#{__MODULE__}] started accepting connections")
    acceptor = Task.async(fn -> accept_connection(listen_socket, service_type) end)
    {:noreply, %{state | acceptor: acceptor}}
  end

  def handle_cast(
        :stop,
        %State{
          acceptor: acceptor
        } = state
      ) do
    Logger.info("[#{__MODULE__}] stopped accepting connections")
    Task.shutdown(acceptor)
    {:noreply, %{state | acceptor: nil}}
  end

  defp init_ssl(port, cert_path) do
    :ssl.start()

    {:ok, socket} =
      :ssl.listen(
        port,
        [{:certfile, Path.join(cert_path, ".crt")}, {:keyfile, Path.join(cert_path, ".key")}]
      )

    socket
  end

  defp accept_connection(
         listen_socket,
         %SSLTCP.ServiceType{
           service: service,
           state_initiator: state_initiator
         } = service_type
       ) do
    {:ok, tls_transport_socket} = :ssl.transport_accept(listen_socket)
    {:ok, peername} = :ssl.peername(tls_transport_socket)

    Logger.info("[#{__MODULE__}] successfully accepted connection with #{inspect(peername)}")

    {:ok, socket} = :ssl.handshake(tls_transport_socket)

    Logger.info("[#{__MODULE__}] successfully handshaked with #{inspect(peername)}")

    {:ok, service} =
      DynamicSupervisor.start_child(
        AuthServ.ServiceSupervisor,
        {service, state_initiator.(socket)}
      )

    Logger.info("#{inspect(service)}")

    accept_connection(listen_socket, service_type)
  end
end
