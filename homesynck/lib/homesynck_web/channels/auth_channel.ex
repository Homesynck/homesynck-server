defmodule HomesynckWeb.AuthChannel do
  import Logger
  use HomesynckWeb, :channel

  @impl true
  def join("auth:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("login", payload, socket) do
    case payload do
      %{"password" => password, "login" => login} ->
        {:reply, authenticate(socket, login, password), socket}

      _ -> {:reply, {:error, %{reason: "wrong params"}}, socket}
    end
  end

  defp authenticate(socket, login, password) do
    params = case is_email?(login) do
      true -> %{"email" => login, "password" => password}
      false -> %{"name" => login, "password" => password}
    end

    #Logger.debug("#{inspect login}, #{inspect password}, #{inspect params}")

    case Homesynck.Auth.authenticate(params) do
      {:ok, id} -> {:ok, %{token: gen_auth_token(id)}}
      error -> {:error, %{reason: "unauthorized"}}
    end
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (auth:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end

  defp is_email?(email) when is_binary(email) do
    case Regex.run(~r/^[\w.!#$%&’*+\-\/=?\^`{|}~]+@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*$/i, email) do
      nil -> false
      [email, _] -> true
    end
  end

  defp is_email?(email) do false end

  defp gen_auth_token(user_id) do
    Phoenix.Token.sign(
      Application.get_env(:homesynck, HomesynckWeb.Endpoint)[:secret_key_base],
      "user auth",
      user_id
    )
  end
end
