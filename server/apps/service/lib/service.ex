defmodule Service do
  use GenServer

  # Types

  # Further defining requires investigation
  @type socket :: any()

  defmodule State do
    @type t :: %__MODULE__{
            socket: Service.socket(),
            service_module: module(),
            name: String.t(),
            session: Map.t()
          }

    defstruct [:socket, :service_module, :name, :session]
  end

  # Behaviour

  @callback on_created(state :: State.t()) ::
              {:ok, new_state :: State.t()}
              | {:error, reason :: any()}
              | {:terminated, result :: any()}

  @callback after_message_received(message :: binary(), state :: State.t()) ::
              {:ok, new_state :: State.t()}
              | {:ignored, reason :: any()}
              | {:error, reason :: any()}
              | {:terminated, result :: any()}

  @callback before_message_sent(message :: binary(), state :: State.t()) ::
              :ok | :abort | {:alter, message :: binary()}

  @callback init_session() :: session :: any()

  @callback get_name() :: name :: String.t()

  # GenServer callbacks

  @spec start_link(service_module: module(), socket: socket()) :: any()
  def start_link(service_module: service_module, socket: socket) do
    GenServer.start_link(
      __MODULE__,
      %State{
        service_module: service_module,
        socket: socket,
        name: "#{service_module.get_name()} #{self()}",
        session: service_module.init_session()
      }
    )
  end

  @spec init(state :: State.t()) :: {:ok, state :: State.t()}
  def init(state) do
    {:ok, state}
  end
end
