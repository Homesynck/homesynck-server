defmodule HomesynckWeb.ControllerLive.Index do
  use HomesynckWeb, :live_view

  alias Homesynck.Sync
  alias Homesynck.Sync.Controller

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :controllers, list_controllers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Controller")
    |> assign(:controller, Sync.get_controller!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Controller")
    |> assign(:controller, %Controller{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Controllers")
    |> assign(:controller, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    controller = Sync.get_controller!(id)
    {:ok, _} = Sync.delete_controller(controller)

    {:noreply, assign(socket, :controllers, list_controllers())}
  end

  defp list_controllers do
    Sync.list_controllers()
  end
end
