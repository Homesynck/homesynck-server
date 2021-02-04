defmodule Server.Protocol do

  @callback init(Server.Socket.t()
  @callback accept(Server.Socket.t()) :: Server.Socket.t()
  @callback receive_blocking(Server.Socket.t()) :: {:ok, binary | list} | {:error, reason}
  @callback send(Server.Socket.t(), binary()) :: :ok | {:error, reason}
end
