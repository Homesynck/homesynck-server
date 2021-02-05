defmodule Server.Service.Ping do
  require Logger
  @behaviour Server.Service

  def init(_opts, send_function) do
    send_function.("HELLO????\n")
    {:ok, 0}
  end

  def on_message(state, message, send_function) when message == "ping" do
    Logger.info("PING: #{state}")
    send_function.("pong\n")
    {:ok, state + 1}
  end

  def on_message(state, message, send_function) do
    Logger.info("#{inspect(message)}")
    Logger.info("#{message == "ping"}")
    Logger.info("#{message == 'ping'}")
    Logger.info("MESSAGE: '#{message}', #{state}")
    {:ok, state}
  end
end
