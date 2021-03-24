defmodule HomesynckWeb.AuthChannel do
  import Logger
  use HomesynckWeb, :channel
  alias HomesynckWeb.AuthTokenHelper

  @impl true
  def join("auth:lobby", payload, socket) do
    if authorized?(payload) do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("login", %{
    "password" => password,
    "login" => login
  }, socket) do

    params =
      case is_email?(login) do
        true -> %{"email" => login, "password" => password}
        false -> %{"name" => login, "password" => password}
      end

    resp = case Homesynck.Auth.authenticate(params) do
      {:ok, user_id} ->
        token = AuthTokenHelper.gen_auth_token(user_id, socket)
        Phoenix.Socket.assign(socket, :auth_token, token)
        {:ok, %{user_id: user_id}}

      {:error, reason} -> {:error, %{reason: reason}}
    end

    {:reply, resp, socket}
  end

  @impl true
  def handle_in("register", %{
    "login" => login,
    "password" => password,
    "register_token" => register_token
  }, socket) do

    resp = case Homesynck.Auth.register(%{
      "register_token" => register_token,
      "name" => login,
      "password" => password
    }) do
      {:ok, user_id} ->
        token = AuthTokenHelper.gen_auth_token(user_id, socket)
        Phoenix.Socket.assign(socket, :auth_token, token)
        {:ok, %{user_id: user_id}}

      {:error, reason} -> {:error, %{reason: reason}}
    end

    {:reply, resp, socket}
  end

  @impl true
  def handle_in("validate_phone", %{
    "phone" => phone
  }, socket) do

    resp = case Homesynck.Auth.validate_phone(phone) do
      {:ok, _} -> {:ok, %{}}
      {:error, reason} -> {:error, %{reason: reason}}
    end

    {:reply, resp, socket}
  end

  @impl true
  def handle_in(_, _, socket) do
    {:reply, {:error, %{reason: "wrong params"}}}
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

  defp is_email?(_) do
    false
  end
end
