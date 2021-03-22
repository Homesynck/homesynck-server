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
        {:reply, authenticate(login, password), socket}
      _ -> {:reply, {:error, %{reason: "wrong params"}}, socket}
    end
  end

  @impl true
  def handle_in("register", payload, socket) do
    case payload do
      %{"login" => login, "password" => password, "register_token" => register_token} ->
        {:reply, register(login, password, register_token), socket}
      _ -> {:reply, {:error, %{reason: "wrong params"}}, socket}
    end
  end

  @impl true
  def handle_in("validate_phone", payload, socket) do
    case payload do
      %{"phone" => phone} -> {:reply, validate_phone(phone), socket}
      _ -> {:reply, {:error, %{reason: "wrong params"}}, socket}
    end
  end

  defp authenticate(login, password) do
    params = case is_email?(login) do
      true -> %{"email" => login, "password" => password}
      false -> %{"name" => login, "password" => password}
    end
    case Homesynck.Auth.authenticate(params) do
      {:ok, id} -> {:ok, %{token: gen_auth_token(id), sync_channel_id: id}}
      error -> {:error, %{reason: "unauthorized"}}
    end
  end

  defp register(login, password, register_token) do
    case Homesynck.Auth.register(%{
      "register_token" => register_token,
      "name" => login,
      "password" => password
    }) do
      {:ok, id} -> {:ok, %{token: gen_auth_token(id), sync_channel_id: id}}
      error ->
        {:error, %{reason: "#{inspect error}"}}
    end
  end

  defp validate_phone(phone) when is_binary(phone) do
    case Homesynck.Auth.validate_phone(phone) do
      {:ok, token} -> {:ok, %{register_token: token}}
      {:error, error} -> {:error, %{reason: error}}
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
