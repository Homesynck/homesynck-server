defmodule Server.Service.Ping do
  require Logger
  @behaviour Server.Service

  def init(_opts, send_function) do
    send_function.("HELLO????\n")
    {:ok, 0}
  end

  def on_message(state, message, send_function) when message == "ping" do
    send_function.("pong #{state}\n")
    {:ok, state + 1}
  end

  def on_message(state, message, send_function) do
    {:ok, state}
  end
end
