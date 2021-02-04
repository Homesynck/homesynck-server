defmodule Server.Service.Ping do
  require Logger
  @behaviour Server.Service

  def init(_opts, send) do
    send.("HELLO????\n")
    {:ok, 0}
  end

  def on_message(state, "ping" = message, send) do
    Logger.info("PING: #{state}")
    send.("pong\n")
    {:ok, state+1}
  end

  def on_message(state, message, send) do
    Logger.info("MESSAGE: #{message}, #{state}")
    {:ok, state}
  end
end
