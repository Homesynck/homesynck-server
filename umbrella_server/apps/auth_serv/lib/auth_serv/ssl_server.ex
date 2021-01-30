defmodule AuthServ.SSLServer do
  @moduledoc """
  Listens for connections and redirects to the appropriate service
  """

  require Logger # using Logger's macros
  use GenServer # building upon GenServer's behaviour

  defmodule State do
    defstruct port: nil,
              listen_socket: nil,
              service_type: nil
  end

  defmodule ServiceType do
    defstruct worker: nil,
              name: "Anonymous",
              state_initiator: nil
  end

  @doc """
  Mendatory GenServer callback
  """
  def start_link(
    %{port: port, service_type: %{worker: worker, state_initiator: si}}
  ) do
    GenServer.start_link(
      __MODULE__,
      %State{
        port: port,
        service_type: %ServiceType{
          worker: worker, state_initiator: si
        }
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
      port: port, service_type: service_type
    } = state
  ) do
    {:ok, listen_socket} = start_listening_ssl(port)
    Logger.info("[#{__MODULE__}] started ssl server on port #{port} for service #{service_type.name}")

    Logger.info("[#{__MODULE__}] started accepting connections")

    accept_connection(listen_socket, service_type)

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

  defp accept_connection(
    listen_socket,
    %ServiceType{
      worker: worker,
      state_initiator: state_initiator
    } = service_type) do
    {:ok, tls_transport_socket} = :ssl.transport_accept(listen_socket)
    {:ok, peername} = :ssl.peername(tls_transport_socket)

    Logger.info("[#{__MODULE__}] successfully accepted connection with #{inspect peername}")

    {:ok, socket} = :ssl.handshake(tls_transport_socket)

    Logger.info("[#{__MODULE__}] successfully handshaked with #{inspect peername}")

    {:ok, worker} = DynamicSupervisor.start_child(
      AuthServ.ServiceSupervisor,
      {worker, state_initiator.(socket)})

    Logger.info("#{inspect worker}")

    accept_connection(listen_socket, service_type)
  end


end
