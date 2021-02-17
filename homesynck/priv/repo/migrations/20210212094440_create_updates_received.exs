defmodule Homesynck.Repo.Migrations.CreateUpdatesReceived do
  use Ecto.Migration

  def change do
    create table(:updates_received) do
      add :update_id, references(:updates, on_delete: :nothing)
      add :controller_id, references(:controllers, on_delete: :delete_all)

      timestamps()
    end

    create index(:updates_received, [:update_id])
    create index(:updates_received, [:controller_id])
  end
end
