defmodule Homesynck.Auth.AdminRegistrator do
  use Task
  require Logger
  alias Homesynck.Repo

  def start_link(_arg) do
    Task.start_link(__MODULE__, :run, [])
  end

  def run() do
    if admin_account_enabled?() do
      run(:enabled)
    else
      run(:disabled)
    end
  end

  def run(:enabled) do
    case Repo.get_by(Homesynck.Auth.User, name: admin_username()) do
      %Homesynck.Auth.User{} = user ->
        account =
          Homesynck.Auth.update_user(user, %{
            "name" => admin_username(),
            "password" => admin_password()
          })

        Logger.info("Admin account updating #{inspect(account)}")

      nil ->
        account =
          Homesynck.Auth.create_user(%{
            "name" => admin_username(),
            "password" => admin_password()
          })

        Logger.info("Admin account creation #{inspect(account)}")
    end
  end

  def run(:disabled) do
    Logger.info("Admin account disabled, not creating")
  end

  defp admin_account_enabled? do
    enable_admin_account = Application.fetch_env!(:homesynck, :enable_admin_account)
    enable_admin_account == "true" or enable_admin_account == true
  end

  defp admin_username do
    Application.fetch_env!(:homesynck, :admin_username)
  end

  defp admin_password do
    Application.fetch_env!(:homesynck, :admin_password)
  end
end
