defmodule AuthServer.AuthService do
  @behaviour Service

  def on_created(state) do
    {:ok, state}
  end

  def after_message_received(message, state) do
    {:ok, state}
  end

  def before_message_sent(message, state) do
    :ok
  end

  def init_session() do
    {}
  end

  def get_name() do
    __MODULE__
  end
end
