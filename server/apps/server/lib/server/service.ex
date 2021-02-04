defmodule Server.Service do
  require Logger
  use Task, restart: :permanent

  @type sender :: (binary() -> :ok)

  @callback init(any(), sender()) :: {:ok, any()}
  @callback on_message(any(), binary(), sender()) :: {:ok, any()}

  def start_link({socket, {protocol_module, _}, {service_module, service_opts}} = args) do
    send_function = init_send_function(socket, protocol_module)
    {:ok, state} = service_module.init(service_opts, send_function)
    Task.start_link(__MODULE__, :run, [args, state, send_function])
  end

  def run({socket, {protocol_module, _}, {service_module, _}} = args, state, send_function) do
    case protocol_module.receive_blocking(socket) do
      {:ok, data} -> {:ok, state} = service_module.on_message(state, data, send_function)
      a -> Logger.info("#{inspect a}")
    end

    run(args, state, send_function)
  end

  def init_send_function(socket, protocol_module) do
    fn message -> protocol_module.send(socket, message) end
  end
end
