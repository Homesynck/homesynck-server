defmodule Homesynck.Repo.Migrations.CreateDirectories do
  use Ecto.Migration

  def change do
    create table(:directories) do
      add :name, :string
      add :description, :string
      add :thumbnail_url, :string
      add :is_secured, :boolean, default: false, null: false
      add :password_hash, :string
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:directories, [:user_id])
    create unique_index(:directories, [:name, :user_id])
  end
end
