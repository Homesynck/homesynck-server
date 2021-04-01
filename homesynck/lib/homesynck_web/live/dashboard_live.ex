defmodule HomesynckWeb.DashboardLive do
  use HomesynckWeb, :live_view

  alias Homesynck.Auth
  alias Homesynck.Sync

  @impl true
  def mount(_params, %{"user_id" => user_id}, socket) do
    user = Auth.get_user!(user_id)

    instance = %{
      name: instance_name(),
      description: instance_description(),
      owner: instance_owner()
    }

    socket =
      socket
      |> assign(user: user, instance: instance)
      |> assign(expanded_directories: [])
      |> assign(expanded_updates: [])
      |> assign(full_updates: [])

    Sync.subscribe(user_id)

    {:ok, fetch(socket)}
  end

  defp fetch(%{assigns: %{user: user}} = socket) do
    directories =
      Sync.get_user_directories(user.id)
      |> Enum.map(fn d ->
        d = Map.put(d, :update_count, Sync.get_update_count(d.id))
        Map.put(d, :last_updates, Sync.get_last_updates(d.id, 10))
      end)

    assign(socket, directories: directories)
  end

  def handle_info({Sync, _, _}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_event("expand", %{"directory_id" => directory_id}, socket) do
    id = elem(Integer.parse(directory_id), 0)
    expanded = [ id | socket.assigns[:expanded_directories]]
    {:noreply,
     assign(socket,
       expanded_directories: expanded
     )}
  end

  def handle_event("collapse", %{"directory_id" => directory_id}, socket) do
    id = elem(Integer.parse(directory_id), 0)
    {:noreply,
     assign(socket,
       expanded_directories:
         List.delete(socket.assigns[:expanded_directories], id)
     )}
  end

  def handle_event("expand", %{"update_id" => update_id}, socket) do
    id = elem(Integer.parse(update_id), 0)
    expanded = [ id | socket.assigns[:expanded_updates]]
    {:noreply,
     assign(socket,
       expanded_updates: expanded
     )}
  end

  def handle_event("collapse", %{"update_id" => update_id}, socket) do
    id = elem(Integer.parse(update_id), 0)
    {:noreply,
     assign(socket,
       expanded_updates:
         List.delete(socket.assigns[:expanded_updates], id)
     )}
  end

  defp instance_name do
    Application.fetch_env!(:homesynck, :instance_name)
  end

  defp instance_description do
    Application.fetch_env!(:homesynck, :instance_description)
  end

  defp instance_owner do
    Application.fetch_env!(:homesynck, :instance_owner)
  end
end
