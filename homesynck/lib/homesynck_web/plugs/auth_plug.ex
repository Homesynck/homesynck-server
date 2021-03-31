defmodule HomesynckWeb.AuthPlug do
  use HomesynckWeb, :controller

  import Plug.Conn
  alias Homesynck.Auth

  def init(opts), do: opts

  def call(conn, _opts) do
    user_id = get_session(conn, :user_id)
    user = user_id && Auth.get_user!(user_id)
    assign(conn, :current_user, user)
  end

  def logged_in_user(conn = %{assigns: %{current_user: %{}}}, _), do: conn

  def logged_in_user(conn, _opts) do
    conn
    |> put_flash(:error, "You must be logged in")
    |> redirect(to: NavigationHistory.last_path(conn, default: "/"))
    |> halt()
  end
end
