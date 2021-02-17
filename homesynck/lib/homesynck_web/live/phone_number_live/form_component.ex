defmodule HomesynckWeb.PhoneNumberLive.FormComponent do
  use HomesynckWeb, :live_component

  alias Homesynck.Auth

  @impl true
  def update(%{phone_number: phone_number} = assigns, socket) do
    changeset = Auth.change_phone_number(phone_number)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"phone_number" => phone_number_params}, socket) do
    changeset =
      socket.assigns.phone_number
      |> Auth.change_phone_number(phone_number_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"phone_number" => phone_number_params}, socket) do
    save_phone_number(socket, socket.assigns.action, phone_number_params)
  end

  defp save_phone_number(socket, :edit, phone_number_params) do
    case Auth.update_phone_number(socket.assigns.phone_number, phone_number_params) do
      {:ok, _phone_number} ->
        {:noreply,
         socket
         |> put_flash(:info, "Phone number updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_phone_number(socket, :new, phone_number_params) do
    case Auth.create_phone_number(phone_number_params) do
      {:ok, _phone_number} ->
        {:noreply,
         socket
         |> put_flash(:info, "Phone number created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
