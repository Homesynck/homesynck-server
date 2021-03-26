defmodule HomesynckWeb.SyncChannel do
  use HomesynckWeb, :channel
  alias Homesynck.Sync

  @impl true
  def join("sync:" <> directory_id, payload, socket) do
    if authorized?(directory_id, payload, socket) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  defp authorized?(directory_id, payload, _socket) do
    # case Sync.get_user_directory_by_name(user_id, dir_name) do
    #   {:ok, directory} ->
    #     secured = directory.is_secured
    #     password = Map.get(payload, "directory_password", "")
    #     not secured or (secured and password == directory.password)

    #   {:error, _} ->
    #     false
    # end
    true
  end

  defp authorized?(_, _, _), do: false
end
