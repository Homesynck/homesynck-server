defmodule Homesynck.Auth.AdminRegistrator do
  use Task

  @enable_admin_account Application.fetch_env!(:homesynck, :enable_admin_account)
  @admin_username Application.fetch_env!(:homesynck, :admin_username)
  @admin_password Application.fetch_env!(:homesynck, :admin_password)

  def start_link(_arg) do
    Task.start_link(__MODULE__, :run, [])
  end

  def run() do
    if @enable_admin_account do
      Homesynck.Auth.create_user(%{
        "name" => @admin_username,
        "password" => @admin_password
      })
      |> IO.inspect()
    else
      IO.puts("Admin account disabled, not creating")
    end
  end
end
