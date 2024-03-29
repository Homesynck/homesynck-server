defmodule Homesynck.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :name, :string
      add :email, :string
      add :password_hashed, :string

      timestamps()
    end
  end
end
