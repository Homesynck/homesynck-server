defmodule HomesynckWeb.SessionController do
  use HomesynckWeb, :controller

  alias HomesynckWeb.Auth

  def new(conn, _) do
    if sessions_enabled?() do
      render(conn, "new.html")
    else
      conn
      |> put_flash(:error, "Sessions disabled on this instance")
      |> redirect(to: "/")
    end
  end

  def delete(conn, _) do
    conn
    |> configure_session(drop: true)
    |> put_flash(:success, "Successfuly signed out")
    |> redirect(to: "/")
  end

  def create(conn, %{"user" => %{"name" => _name, "password" => _password} = form}) do
    case Homesynck.Auth.authenticate(form) do
      {:ok, user_id} ->
        conn
        |> put_session(:user_id, user_id)
        |> configure_session(renew: true)
        |> redirect(to: "/dashboard")

      _ ->
        conn
        |> put_flash(:error, "Bad name/password combination")
        |> redirect(to: Routes.session_path(conn, :new))
    end
  end

  defp sessions_enabled? do
    enable_sessions = Application.fetch_env!(:homesynck, :enable_sessions)
    enable_sessions == "true" or enable_sessions == true
  end
end
