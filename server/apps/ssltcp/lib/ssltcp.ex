defmodule Ssltcp do
  @moduledoc """
  Listens for connections and redirects to the appropriate service
  """

  # using Logger's macros
  require Logger
  # building upon GenServer's behaviour
  use GenServer

  defmodule State do
    @type t :: %__MODULE__{
            port: integer(),
            listen_socket: Service.socket() | nil,
            service_module: module(),
            cert_path: binary(),
            acceptor: Task.t() | nil
          }

    defstruct [:port, :listen_socket, :service_module, :cert_path, :acceptor]
  end

  @spec start(pid :: pid()) :: :ok
  def start(pid) do
    listen_socket = GenServer.call(pid, :listen)
    GenServer.cast(pid, {:start, listen_socket})
  end

  @spec stop(pid :: pid()) :: :ok
  def stop(pid) do
    GenServer.cast(pid, :stop)
  end

  @doc """
  Build options for supervision
  """
  @spec sup_opts(
          port :: integer(),
          service_module :: module(),
          certificate_path :: binary()
        ) :: State.t()
  def sup_opts(port, service_module, certificate_path) do
    %State{
      :port => port,
      :cert_path => certificate_path,
      :service_module => service_module
    }
  end

  @doc """
  Mendatory GenServer callback
  """
  @spec start_link(state :: State.t()) :: any()
  def start_link(state) do
    {:ok, pid} =
      GenServer.start_link(
        __MODULE__,
        state,
        name: __MODULE__
      )

    start(pid)
    {:ok, pid}
  end

  @doc """
  Mendatory GenServer callback that asynchronously triggers handle_continue
  """
  def init(%State{} = state) do
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
          service_module: service_module
        } = state
      ) do
    Logger.info("[#{__MODULE__}] started accepting connections")
    acceptor = Task.async(fn -> accept_connection(listen_socket, service_module) end)
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

  @spec accept_connection(listen_socket :: any(), service_module :: module()) :: any()
  defp accept_connection(listen_socket, service_module) do
    {:ok, tls_transport_socket} = :ssl.transport_accept(listen_socket)
    {:ok, peername} = :ssl.peername(tls_transport_socket)

    Logger.info("[#{__MODULE__}] successfully accepted connection with #{inspect(peername)}")

    {:ok, socket} = :ssl.handshake(tls_transport_socket)

    Logger.info("[#{__MODULE__}] successfully handshaked with #{inspect(peername)}")

    {:ok, service} =
      DynamicSupervisor.start_child(
        AuthServ.ServiceSupervisor,
        {Service, [service_module: service_module, socket: socket]}
      )

    Logger.info("#{inspect(service)}")

    accept_connection(listen_socket, service_module)
  end
end
