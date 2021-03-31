defmodule Homesynck.Repo.Migrations.UsersAddLoginToken do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :login_hash, :string
    end
  end
end
