defmodule HomesynckWeb.PhoneNumberLive.Index do
  use HomesynckWeb, :live_view

  alias Homesynck.Auth
  alias Homesynck.Auth.PhoneNumber

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :phone_numbers, list_phone_numbers())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Phone number")
    |> assign(:phone_number, Auth.get_phone_number!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Phone number")
    |> assign(:phone_number, %PhoneNumber{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Phone numbers")
    |> assign(:phone_number, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    phone_number = Auth.get_phone_number!(id)
    {:ok, _} = Auth.delete_phone_number(phone_number)

    {:noreply, assign(socket, :phone_numbers, list_phone_numbers())}
  end

  defp list_phone_numbers do
    Auth.list_phone_numbers()
  end
end
