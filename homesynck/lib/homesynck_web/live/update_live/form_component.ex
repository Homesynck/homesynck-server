defmodule HomesynckWeb.UpdateLive.FormComponent do
  use HomesynckWeb, :live_component

  alias Homesynck.Sync

  @impl true
  def update(%{update: update} = assigns, socket) do
    changeset = Sync.change_update(update)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"update" => update_params}, socket) do
    changeset =
      socket.assigns.update
      |> Sync.change_update(update_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"update" => update_params}, socket) do
    save_update(socket, socket.assigns.action, update_params)
  end

  defp save_update(socket, :edit, update_params) do
    case Sync.update_update(socket.assigns.update, update_params) do
      {:ok, _update} ->
        {:noreply,
         socket
         |> put_flash(:info, "Update updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_update(socket, :new, update_params) do
    case Sync.create_update(update_params) do
      {:ok, _update} ->
        {:noreply,
         socket
         |> put_flash(:info, "Update created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
