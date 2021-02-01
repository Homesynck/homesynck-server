defmodule Service do
  use GenServer

  @type socket :: record(any())

  defmodule State do
    @type t :: %__MODULE__{
            socket: socket,
            callback_module: :atom,
            name: String.t(),
            session: Map.t()
          }

    @enforce_keys [:socket, :callback_module]
    defstruct [:socket, :callback_module, :name, :session]
  end

  @callback on_created(message :: binary(), state :: State.t()) ::
              {:ok, new_state :: State.t()}
              | {:error, reason :: any()}
              | {:terminated, result :: any()}

  @callback after_message_received(message :: binary(), state :: State.t()) ::
              {:ok, new_state :: State.t()}
              | {:ignored, reason :: any()}
              | {:error, reason :: any()}
              | {:terminated, result :: any()}

  @callback before_message_sent(message :: binary()) :: :ok | :abort

  @callback init_session() :: session :: any()

  # TODO : init session

  @spec start_link(callback_module :: atom()) :: on_start
  def start_link(
        %Template{
          callback_module: callback_module
        } = template
      ) do
    GenServer.start_link(__MODULE__, %State{})
  end

  @spec init(state :: State.t()) :: {:ok, state :: State.t()}
  def init(state) do
    {:ok, state}
  end

  @impl true
  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  @impl true
  def handle_cast({:push, element}, state) do
    {:noreply, [element | state]}
  end
end
