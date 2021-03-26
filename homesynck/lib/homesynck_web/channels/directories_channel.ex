defmodule HomesynckWeb.DirectoriesChannel do
  use HomesynckWeb, :channel
  alias Homesynck.Sync
  alias HomesynckWeb.AuthTokenHelper

  @impl true
  def join("directories:lobby", _payload, socket) do
    if authorized?(socket) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in(
        "create",
        %{
          "name" => dir_name,
          "description" => _dir_description,
          "thumbnail_url" => _dir_thumbnail_url,
          "is_secured" => _dir_is_secured,
          "password" => _dir_password
        } = payload,
        %{
          assigns: %{user_id: user_id}
        } = socket
      ) do
    resp =
      case Sync.get_user_directory_by_name(user_id, dir_name) do
        {:ok, directory} ->
          {:ok, %{directory_id: directory.id}}

        {:error, :not_found} ->
          case Sync.create_directory_for(user_id, payload) do
            {:ok, directory_id} -> {:ok, %{directory_id: directory_id}}
            error -> {:error, %{reason: inspect(error)}}
          end

        {:error, reason} ->
          {:error, %{reason: inspect(reason)}}
      end

    {:reply, resp, socket}
  end

  @impl true
  def handle_in(
        "open",
        %{"name" => dir_name},
        %{assigns: %{user_id: user_id}} = socket
      ) do
    resp =
      case Sync.get_user_directory_by_name(user_id, dir_name) do
        {:ok, directory} ->
          {:ok, %{directory_id: directory.id}}

        {:error, :not_found} ->
          {:error, %{reason: "not found"}}

        {:error, reason} ->
          {:error, %{reason: inspect(reason)}}
      end

    {:reply, resp, socket}
  end

  defp authorized?(
         %{
           assigns: %{
             auth_token: auth_token,
             user_id: user_id
           }
         } = socket
       ) do
    AuthTokenHelper.auth_token_valid?(user_id, auth_token, socket)
  end

  defp authorized?(socket) do
    IO.puts("SOCKET_UNAUTHORIZED: #{inspect socket}")
    false
  end

  @impl true
  def handle_in(_, _, socket) do
    {:reply, {:error, %{reason: "wrong params"}}, socket}
  end
end
