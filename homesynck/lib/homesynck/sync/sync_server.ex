defmodule Homesynck.Sync.SyncServer do
  use GenServer
  require Logger
  alias Homesynck.Sync

  @ttl 3_600_000

  def call(context, sync_id, request) do
    if not exists?(context, sync_id) do
      renew(context, sync_id)
    end

    name = build_name(context, sync_id)
    GenServer.call(name, request)
  end

  def renew(context, sync_id) do
    name = build_name(context, sync_id)
    {:ok, _} = GenServer.start_link(__MODULE__, {context, sync_id}, name: name)
  end

  def exists?(context, sync_id) do
    name = build_name(context, sync_id)

    case GenServer.whereis(name) do
      nil -> false
      _pid -> true
    end
  end

  @impl true
  def init({context, sync_id}) do
    {:ok, {context, sync_id}, @ttl}
  end

  @impl true
  def handle_info(:timeout, {context, sync_id}) do
    IO.puts('Sending timeout for #{build_name(context, sync_id)}')
    {:stop, :timeout, []}
  end

  @impl true
  def handle_call(
        {:push_update, update_attrs},
        _from,
        {:directory, directory_id} = state
      ) do
    resp =
      with {:ok, directory} <- Sync.get_directory(directory_id),
           {:ok, update} <- push_update_to_directory(directory, update_attrs) do
        Logger.info("Push update success #{inspect(update)}")
        {:ok, update}
      else
        error ->
          Logger.info("Push update error #{inspect(error)}")
          error
      end

    {:reply, resp, state, @ttl}
  end

  def push_update_to_directory(
        %Sync.Directory{
          current_rank: current_rank
        } = directory,
        %{"rank" => rank} = update_attrs
      )
      when current_rank == rank - 1 do
    case Sync.push_update_transaction(directory, update_attrs) do
      {:ok, update} -> {:ok, update}
      {:error, reason} -> {:error, reason}
    end
  end

  def push_update_to_directory(_, _), do: {:error, :invalid_update}

  defp build_name(context, sync_id) do
    :"#{context}#{sync_id}"
  end
end
