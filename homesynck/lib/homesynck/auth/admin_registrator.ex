defmodule Homesynck.Auth.AdminRegistrator do
  use Task
  require Logger
  alias Homesynck.Repo

  @enable_admin_account Application.fetch_env!(:homesynck, :enable_admin_account)
  @admin_username Application.fetch_env!(:homesynck, :admin_username)
  @admin_password Application.fetch_env!(:homesynck, :admin_password)

  def start_link(_arg) do
    Task.start_link(__MODULE__, :run, [])
  end

  def run() do
    if @enable_admin_account do
      case Repo.get_by(Homesynck.Auth.User, name: @admin_username) do
        %Homesynck.Auth.User{} = user ->
          account = Homesynck.Auth.update_user(user, %{
            "name" => @admin_username,
            "password" => @admin_password
          })
          Logger.info("Admin account updating #{inspect account}")

        nil ->
          account = Homesynck.Auth.create_user(%{
            "name" => @admin_username,
            "password" => @admin_password
          })
          Logger.info("Admin account creation #{inspect account}")
      end
    else
      Logger.info("Admin account disabled, not creating")
    end
  end
end
