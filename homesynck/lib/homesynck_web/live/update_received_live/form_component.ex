defmodule HomesynckWeb.UpdateReceivedLive.FormComponent do
  use HomesynckWeb, :live_component

  alias Homesynck.Sync

  @impl true
  def update(%{update_received: update_received} = assigns, socket) do
    changeset = Sync.change_update_received(update_received)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"update_received" => update_received_params}, socket) do
    changeset =
      socket.assigns.update_received
      |> Sync.change_update_received(update_received_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"update_received" => update_received_params}, socket) do
    save_update_received(socket, socket.assigns.action, update_received_params)
  end

  defp save_update_received(socket, :edit, update_received_params) do
    case Sync.update_update_received(socket.assigns.update_received, update_received_params) do
      {:ok, _update_received} ->
        {:noreply,
         socket
         |> put_flash(:info, "Update received updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_update_received(socket, :new, update_received_params) do
    case Sync.create_update_received(update_received_params) do
      {:ok, _update_received} ->
        {:noreply,
         socket
         |> put_flash(:info, "Update received created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
