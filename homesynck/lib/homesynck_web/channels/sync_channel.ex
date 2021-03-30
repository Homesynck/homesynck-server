defmodule HomesynckWeb.SyncChannel do
  use HomesynckWeb, :channel
  require Logger
  alias Homesynck.Sync
  alias HomesynckWeb.AuthTokenHelper

  @impl true
  def join(
        "sync:" <> directory_id,
        %{
          "directory_password" => _password,
          "auth_token" => auth_token,
          "user_id" => user_id,
          "received_updates" => received_updates
        } = payload,
        socket
      )
      when is_list(received_updates) do
    if authorized?(directory_id, payload, socket) do
      socket =
        socket
        |> Phoenix.Socket.assign(:auth_token, auth_token)
        |> Phoenix.Socket.assign(:user_id, user_id)
        |> Phoenix.Socket.assign(:directory_id, directory_id)

      payload = case send_missing_updates(received_updates, directory_id, socket) do
        {:ok, count} ->
          %{missing_count: count}
        _ -> %{}
      end
      {:ok, payload, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def join(_, _, _), do: {:error, %{reason: "wrong params"}}

  @impl true
  def handle_in(
        "push_update",
        %{
          "rank" => _rank,
          "instructions" => _instructions
        } = update_attrs,
        %{assigns: %{directory_id: directory_id}} = socket
      ) do
    Logger.info("Received push_update #{inspect(update_attrs)}")

    resp =
      case Sync.push_update_sync(directory_id, update_attrs) do
        {:ok, update} ->
          broadcast_updates([update], socket)
          {:ok, %{:update_id => update.id}}

        {:error, :not_found} ->
          {:error, %{:reason => "directory not found"}}

        {:error, _error} ->
          {:error, %{:reason => "update pushing failed"}}
      end

    Logger.info("Responding to push_update #{inspect(resp)}")
    {:reply, resp, socket}
  end

  @impl true
  def handle_in(_, _, socket) do
    {:reply, {:error, %{reason: "wrong params"}}, socket}
  end

  @impl true
  def handle_info({:send_missing, missing_updates}, socket) do
    Logger.info("Sending after join: #{inspect missing_updates}")
    send_updates(missing_updates, socket)
    {:noreply, socket}
  end

  defp authorized?(
         directory_id,
         %{
           "directory_password" => password,
           "auth_token" => auth_token,
           "user_id" => user_id
         },
         socket
       ) do
    with true <- AuthTokenHelper.auth_token_valid?(user_id, auth_token, socket),
         {:ok, %Sync.Directory{}} <- Sync.open_directory(directory_id, user_id, password) do
      true
    else
      _ -> false
    end
  end

  defp authorized?(_, _, _), do: false

  defp send_missing_updates(received_updates, directory_id, _socket) do
    with {:ok, directory} <- Sync.get_directory(directory_id),
         missing_updates <- Sync.get_missing_updates(directory, received_updates) do
      send(self(), {:send_missing, missing_updates})
      {:ok, length(missing_updates)}
    else
      {:error, :not_found} -> {:error, :not_found}
    end
  end

  defp send_updates(updates, socket) do
    updates
    |> build_updates()
    |> (&push(socket, "updates", %{"updates" => &1})).()
  end

  defp broadcast_updates(updates, from_socket) do
    updates
    |> build_updates()
    |> (&broadcast(from_socket, "updates", %{"updates" => &1})).()
    |> (&(Logger.info("Broadcasting updates #{inspect &1}"))).()
  end

  defp build_updates(updates) do
    updates
    |> IO.inspect()
    |> Enum.map(&%{"rank" => &1.rank, "instructions" => &1.instructions})
  end
end
