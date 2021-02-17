defmodule HomesynckWeb.UpdateReceivedLive.Index do
  use HomesynckWeb, :live_view

  alias Homesynck.Sync
  alias Homesynck.Sync.UpdateReceived

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :updates_received, list_updates_received())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Update received")
    |> assign(:update_received, Sync.get_update_received!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Update received")
    |> assign(:update_received, %UpdateReceived{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Updates received")
    |> assign(:update_received, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    update_received = Sync.get_update_received!(id)
    {:ok, _} = Sync.delete_update_received(update_received)

    {:noreply, assign(socket, :updates_received, list_updates_received())}
  end

  defp list_updates_received do
    Sync.list_updates_received()
  end
end
