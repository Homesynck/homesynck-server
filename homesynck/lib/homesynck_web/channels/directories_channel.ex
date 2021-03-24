defmodule HomesynckWeb.DirectoriesChannel do
  use HomesynckWeb, :channel

  @impl true
  def join("directories:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end



  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
