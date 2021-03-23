defmodule Homesynck.Repo.Migrations.AddUpdatesEmitters do
  use Ecto.Migration

  def change do
    alter table(:updates) do
      add :emitter_id, references(:users, on_delete: :delete_all)
    end

    create index(:updates, [:emitter_id])
  end
end
