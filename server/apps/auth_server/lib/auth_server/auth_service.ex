defmodule AuthServer.AuthService do
  require Logger
  @behaviour Server.Service

  def init(_opts, send_function) do
    send_function.("Welcome to Homesynck authentication service\n")
    {:ok, %{}}
  end

  def on_message(state, "registerphone", send_function) do
    send_function.("pong #{inspect state}\n")
    {:ok, state}
  end

  def on_message(state, message, send_function) do
    send_function.("error")
    {:ok, state}
  end
end
