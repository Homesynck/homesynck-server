defmodule HomesynckWeb.SyncChannel do
  use HomesynckWeb, :channel
  alias Homesynck.Sync
  alias HomesynckWeb.AuthTokenHelper

  @impl true
  def join("sync:" <> directory_id, payload, socket) do
    if authorized?(directory_id, payload, socket) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("push_update", %{
    "rank" => rank,
    "instructions" => instructions
  }) do

  end

  defp authorized?(
         directory_id,
         %{"directory_password" => password},
         %{
           assigns: %{
             user_id: user_id,
             auth_token: auth_token
           }
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
end
