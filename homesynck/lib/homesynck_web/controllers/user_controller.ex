defmodule HomesynckWeb.UserController do
  use HomesynckWeb, :controller

  alias HomesynckWeb.Auth

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, _) do

  end
end
