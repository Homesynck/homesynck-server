defmodule HomesynckWeb.LayoutView do
  use HomesynckWeb, :view

  def current_user(conn) do
    Plug.Conn.get_session(conn, :user_id)
  end

  defp sessions_enabled? do
    enable_sessions = Application.fetch_env!(:homesynck, :enable_sessions)
    enable_sessions == "true" or enable_sessions == true
  end
end
