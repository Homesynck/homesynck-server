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
    new_state = case protocol_module.receive_blocking(socket) do
      {:ok, [_, _ | data]} ->
        message = List.to_string(data)
        Logger.info("[#{__MODULE__} ~ #{service_module}] socket received message #{inspect message}")
        {:ok, new_state} = service_module.on_message(state, message, send_function)
        new_state

      _ -> state
    end

    run(args, new_state, send_function)
  end

  def init_send_function(socket, protocol_module) do
    fn message -> protocol_module.send(socket, message) end
  end
end
