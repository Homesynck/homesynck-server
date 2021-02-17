defmodule HomesynckWeb.ControllerLive.FormComponent do
  use HomesynckWeb, :live_component

  alias Homesynck.Sync

  @impl true
  def update(%{controller: controller} = assigns, socket) do
    changeset = Sync.change_controller(controller)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"controller" => controller_params}, socket) do
    changeset =
      socket.assigns.controller
      |> Sync.change_controller(controller_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"controller" => controller_params}, socket) do
    save_controller(socket, socket.assigns.action, controller_params)
  end

  defp save_controller(socket, :edit, controller_params) do
    case Sync.update_controller(socket.assigns.controller, controller_params) do
      {:ok, _controller} ->
        {:noreply,
         socket
         |> put_flash(:info, "Controller updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_controller(socket, :new, controller_params) do
    case Sync.create_controller(controller_params) do
      {:ok, _controller} ->
        {:noreply,
         socket
         |> put_flash(:info, "Controller created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
