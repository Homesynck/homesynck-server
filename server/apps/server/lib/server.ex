defmodule Server do
  @moduledoc """
  A module that implements a networking service/server behaviour.

  A server is composed of three things:
  - a `listener`, a supervised task that listens for incoming connections
  - a bunch of `services` created by the `listener` on every connection
  - a `message_handler`, a module implementing the `Server.Service.MessageHandler`
    behaviour that handles incoming messages and can send messages back
  """
  use Supervisor

  @services_sup ServicesSupervisor

  def on_connection(
        %{
          server_name: server_name,
          services_supervisor: services_supervisor,
          message_handler: message_handler,
          message_handler_arg: message_handler_arg
        } = _callback_data,
        client_socket
      ) do
    {:ok, pid} =
      DynamicSupervisor.start_child(
        services_sup_name(server_name),
        {message_handler, :start_link,
         [
           %{
             client_socket: client_socket,
             message_handler: message_handler,
             message_handler_arg: message_handler_arg
           }
         ]}
      )
  end

  def start_link(%{name: name} = init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: name)
  end

  @impl true
  def init(
        %{
          name: name,
          listener_module: listener_module,
          listener_arg: listener_arg,
          message_handler: message_handler,
          message_handler_arg: message_handler_arg
        } = _init_arg
      ) do
    services_supervisor = services_sup_name(name)

    callback_data = %{
      server_name: server_name,
      services_supervisor: services_supervisor,
      message_handler: message_handler,
      message_handler_arg: message_handler_arg
    }

    children = [
      {@services_sup, name: services_supervisor},
      {listener_module, :start_link, [callback_data, listener_arg],
       name: :"#{server_name}.#{listener_module}"}
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp services_sup_name(server_name) do
    :"#{server_name}.#{@services_sup}"
  end
end
