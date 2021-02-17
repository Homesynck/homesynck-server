defmodule Homesynck.Repo.Migrations.CreateControllers do
  use Ecto.Migration

  def change do
    create table(:controllers) do
      add :name, :string
      add :last_online, :date
      add :owner, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:controllers, [:owner])
  end
end
