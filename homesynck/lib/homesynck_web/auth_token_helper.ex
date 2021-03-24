defmodule HomesynckWeb.AuthTokenHelper do
  def gen_auth_token(user_id, socket) do
    Phoenix.Token.sign(
      socket,
      "user auth",
      user_id
    )
  end

  def verify_auth_token(user_id, token) do

  end
end
