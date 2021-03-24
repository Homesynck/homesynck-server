defmodule HomesynckWeb.AuthTokenHelper do
  def gen_auth_token(user_id, socket) do
    Phoenix.Token.sign(
      socket,
      "user auth",
      user_id
    )
  end
end
