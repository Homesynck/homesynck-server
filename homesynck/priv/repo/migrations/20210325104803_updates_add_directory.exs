defmodule Homesynck.Repo.Migrations.UpdatesAddDirectory do
  use Ecto.Migration

  def change do
    alter table(:updates) do
      add :directory_id, references(:directories, on_delete: :delete_all)
    end

    create index(:updates, [:directory_id])
    create unique_index(:updates, [:rank, :directory_id])
  end
end
