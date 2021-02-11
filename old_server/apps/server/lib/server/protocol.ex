defmodule Server.Protocol do
  @callback init(any()) :: Server.Socket.t()
  @callback accept(Server.Socket.t()) :: Server.Socket.t()
  @callback receive_blocking(Server.Socket.t()) :: {:ok, binary() | list()} | {:error, any()}
  @callback send(Server.Socket.t(), binary()) :: :ok | {:error, any()}
end
