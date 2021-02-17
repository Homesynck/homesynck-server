defmodule Homesynck.Repo.Migrations.AddUpdatesEmitters do
  use Ecto.Migration

  def change do
    alter table(:updates) do
      add :emitter_id, references(:controllers, on_delete: :nothing)
    end

    create index(:updates, [:emitter_id])
  end
end
