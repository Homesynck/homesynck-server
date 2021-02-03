defmodule Server.Service do
  use Supervisor

  def start_link(client_socket, message_handler, message_handler_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    children = []

    Supervisor.init(children, strategy: :one_for_one)
  end
end
