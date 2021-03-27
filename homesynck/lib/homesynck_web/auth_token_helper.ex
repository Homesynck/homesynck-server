defmodule HomesynckWeb.AuthTokenHelper do
  def gen_auth_token(user_id, socket) do
    token =
      Phoenix.Token.sign(
        socket,
        "user auth",
        user_id
      )

    token
  end

  def auth_token_valid?(user_id, token, socket) do
    result = Phoenix.Token.verify(socket, "user auth", token, max_age: 86_400)

    case result do
      {:ok, result_user_id} ->
        IO.puts("#{user_id}:#{result_user_id}")

        if user_id == "#{result_user_id}" do
          true
        else
          false
        end
      _ ->
        IO.puts("rejected token #{user_id}:#{token}")
        false
    end
  end
end
