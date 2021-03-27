defmodule HomesynckWeb.PageController do
  use HomesynckWeb, :controller

  plug :action

  def index(conn, _params) do
    render conn, "index.html"
  end
end
