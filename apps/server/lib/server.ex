defmodule Server do
  @moduledoc """
  Documentation for `Server`.
  """

  defmodule State do
    defstruct port: 3000,
              mode: "ssl",
              host: "*",
              socket: nil
  end

  def start(port, cert_path, key_path) do
    start({0,0,0,0}, port, cert_path, key_path)
  end

  def start(addr, port, cert_path, key_path) do
    :ok = :esockd.start()
    tcp_opts = [:binary, {:reuseaddr, true}]
    ssl_opts = [{:certfile, cert_path}, {:keyfile, key_path}]
    opts = [{:active, false}, {:acceptors, 4}, {:max_connections, 1000}, {:tcp_options, tcp_opts}, {:ssl_options, ssl_opts}]
    {:ok, _} = :esockd.open(:machin, {addr, port}, opts, __MODULE__)
  end

  # -----------------
  # esockd callbacks
  # -----------------

  def start_link(transport, sock) do
    {:ok, GenServer.start_link(__MODULE__, [transport, sock])}
  end

  def init(transport, sock) do
    case transport.wait(sock) do
        {:ok, new_sock} ->
            IO.puts "connection received #{new_sock}"
            loop(transport, new_sock)
        error -> error
    end
  end

  def loop(transport, sock) do
    case transport.recv(sock, 0) do
        {:ok, data} ->
            {:ok, peer_name} = transport.peername(sock)
            IO.puts "message received from #{peer_name} : #{data}"
            transport.send(sock, data)
            loop(transport, sock)
        {:error, reason} ->
            IO.puts "tcp error #{reason}"
            {:stop, reason}
    end
  end



  # def start_link(%State{} = state) do
  #   GenServer.start_link(__MODULE__, state)
  # end

  # def init(%State{} = state) do
  #   {:ok, state}
  # end

  # def handle_call(:listen, _from, %{port: port, mode: mode, host: host} = state) do
  #   {:ok, socket} = Socket.listen("#{mode}://#{host}:#{port}")
  #   {:reply, {:ok, socket}, %{state | socket: socket}}
  # end

  # def handle_call(:getsocket, _from, %{socket: socket} = state) when socket != nil do
  #   {:reply, {:ok, socket}, state}
  # end
end
