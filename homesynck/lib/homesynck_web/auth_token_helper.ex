defmodule HomesynckWeb.AuthTokenHelper do
  def gen_auth_token(user_id, socket) do
    token =
      Phoenix.Token.sign(
        socket,
        "user auth",
        user_id
      )

    IO.puts("TOKEN_GENERATED\n#{inspect(socket)}\n---> #{user_id}:#{token}")

    token
  end

  def auth_token_valid?(user_id, token, socket) do
    result = Phoenix.Token.verify(socket, "user auth", token, max_age: 86_400)

    IO.puts("TOKEN_VALID?\n#{inspect(socket)}\n---> #{user_id}:#{token}:#{inspect(result)}")

    case result do
      {:ok, _} -> true
      _ -> false
    end
  end
end
