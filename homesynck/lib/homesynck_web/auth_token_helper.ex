defmodule HomesynckWeb.AuthTokenHelper do
  def gen_auth_token(user_id, socket) do
    Phoenix.Token.sign(
      socket,
      "user auth",
      user_id
    )
  end

  def auth_token_valid?(user_id, token, socket) do
    case Phoenix.Token.verify(socket, "user auth", token, max_age: 86_400) do
      {:ok, ^user_id} -> true
      _ -> false
    end
  end
end
