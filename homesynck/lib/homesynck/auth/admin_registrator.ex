defmodule Homesynck.Auth.AdminRegistrator do
  use Task
  require Logger
  alias Homesynck.Repo

  def start_link(_arg) do
    Task.start_link(__MODULE__, :run, [])
  end

  def run() do
    if enable_admin_account? do
      case Repo.get_by(Homesynck.Auth.User, name: admin_username) do
        %Homesynck.Auth.User{} = user ->
          account =
            Homesynck.Auth.update_user(user, %{
              "name" => admin_username,
              "password" => admin_password
            })

          Logger.info("Admin account updating #{inspect(account)}")

        nil ->
          account =
            Homesynck.Auth.create_user(%{
              "name" => admin_username,
              "password" => admin_password
            })

          Logger.info("Admin account creation #{inspect(account)}")
      end
    else
      Logger.info("->>>>>>>>>>>#{System.get_env("ENABLE_ADMIN_ACCOUNT")}")
      Logger.info("Admin account disabled, not creating")
    end
  end

  defp enable_admin_account? do
    Application.fetch_env!(:homesynck, :enable_admin_account)
  end

  defp admin_username do
    Application.fetch_env!(:homesynck, :admin_username)
  end

  defp admin_password do
    Application.fetch_env!(:homesynck, :admin_password)
  end
end
