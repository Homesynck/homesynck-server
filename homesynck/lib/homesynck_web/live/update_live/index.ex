defmodule HomesynckWeb.UpdateLive.Index do
  use HomesynckWeb, :live_view

  alias Homesynck.Sync
  alias Homesynck.Sync.Update

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :updates, list_updates())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Update")
    |> assign(:update, Sync.get_update!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Update")
    |> assign(:update, %Update{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Updates")
    |> assign(:update, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    update = Sync.get_update!(id)
    {:ok, _} = Sync.delete_update(update)

    {:noreply, assign(socket, :updates, list_updates())}
  end

  defp list_updates do
    Sync.list_updates()
  end
end
