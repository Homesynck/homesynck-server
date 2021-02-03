defmodule Server.Listener do
  require Logger

  defmacro __using__(_opts) do
    listener_impl = __CALLER__.module

    quote location: :keep, bind_quoted: [opts: opts] do
      use Task
      @behaviour Server.Listener

      def child_spec(callback_data, listener_arg) do
        default = %{
          id: __MODULE__,
          start: {unquote(listener_impl), :start_link, [callback_data, listener_arg]}
        }

        Supervisor.child_spec(default, unquote(Macro.escape(opts)))
      end

      def start_link(callback_data, listener_arg) do
        listen_socket = init_listen_socket(listener_arg)
        Task.start_link(unquote(listener_impl), :run, [callback_data, listen_socket])
      end

      def run(callback_data, listen_socket) do
        client_socket = listen(listen_socket)
        __MODULE__.on_connection(callback_data, client_socket)

        run(callback_data, listen_socket)
      end

      # defoverridable run: 1
    end
  end

  @callback listen(listen_socket) :: client_socket :: Server.Socket.t()

  @callback init_listen_socket(arg) :: listen_socket :: Server.Socket.t()

  def on_connection(callback_data, client_socket) do
    Logger.info("#{inspect(callback_data)}")
    Logger.info("#{inspect(client_socket)}")
    Server.on_connection(callback_data, client_socket)
  end
end
