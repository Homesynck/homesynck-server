defmodule HomesynckWeb.PageController do
  use HomesynckWeb, :controller
  import HomesynckWeb.AuthPlug, only: [logged_in_user: 2]

  plug :logged_in_user when action in [:dashboard]

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def dashboard(conn, _params) do
    render(conn, "index.html")
  end
end
