defmodule HomesynckWeb.PhoneNumberLive.Show do
  use HomesynckWeb, :live_view

  alias Homesynck.Auth

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:phone_number, Auth.get_phone_number!(id))}
  end

  defp page_title(:show), do: "Show Phone number"
  defp page_title(:edit), do: "Edit Phone number"
end
