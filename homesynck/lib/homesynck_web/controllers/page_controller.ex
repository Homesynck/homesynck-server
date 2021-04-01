defmodule HomesynckWeb.PageController do
  use HomesynckWeb, :controller
  import HomesynckWeb.AuthPlug, only: [logged_in_user: 2]

  plug :logged_in_user when action in [:dashboard]

  def index(conn, _params) do
    conn
    |> assign(:excluded_nav, ["/"])
    |> render("index.html")
  end

  def dashboard(conn, _params) do
    conn
    |> assign(:excluded_nav, ["/dashboard"])
    |> render("dashboard.html")
  end
end
